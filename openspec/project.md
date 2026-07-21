# Project Context

## Purpose

Spec workspace for the **Project Register / Project Management** feature of Syndome CRM — a new module for sales teams to register prospective projects (โครงการ), track cost/price via a Project Management (PM) task table, and run the project through a multi-level approval workflow to a final outcome (won / lost / closed).

This workspace is intentionally **separate from the implementation repo(s)** because the spec should stay the single source of truth regardless of how the code is split. As of 2026-07-21 this is a **full re-platform**: the feature is no longer built inside the existing Syndome CRM codebase.

- Implementation repos are **new and not yet created/named** — a React web app and a Node.js/Fastify API (mono-repo or two repos, not yet decided — see `9b.6` in the impact assessment).
- The old repos (`syndome-crm-mvc-ui`, `syndome-crm-api`, .NET/SQL Server 2016) are **no longer used by this feature at all** — kept here only as historical context for decisions made before the pivot.

The full narrative impact assessment (prototype comparison, open questions, decision log, DDL draft, API contract draft, field mapping, test scenarios) lives at `D:\Project Dear\project-regis\docs\impact-assessment-project-register.md` and is the primary source this spec was derived from. Read it for the "why" behind any requirement here; this spec is the normative "what." **Section `0c` of that document explains the tech stack pivot; section `9b` lists the stack/infra questions still open; section `9c` closes the SSO/auth questions with concrete integration details.**

## Tech Stack

- **UI**: React (SPA). Design system/component library not yet chosen (MUI / Ant Design / Chakra / Tailwind — open, see impact assessment `9b.7`).
- **API**: Node.js + Fastify. ORM/query layer for Postgres not yet chosen (Prisma / Drizzle / Knex+pg — open, see `9b.4`).
- **Database**: PostgreSQL (15+ recommended). Schema `project`, `snake_case` table/column names (DB) mapped to `camelCase` JSON (API/UI).
- **Auth**: **SSO Management** — the org's existing internal Authentication Gateway, backed by Active Directory/LDAP. This app uses the **OAuth2 Authorization Code Flow** (token exchange happens server-side in Fastify, never in the browser). Identity is a JWT (RS256) verified locally via a public key (no per-request callback to the IdP). Role/permission comes directly from the JWT `roles` claim — an app-specific array the SSO admin maps per `client_id` via `group_role_map` — so **there is no local role table**; only a lightweight `auth.user` provisioning-cache table (populated on first login) is needed. Full protocol detail, endpoint list, and gotchas are in impact assessment `9c`. The one remaining internal choice — BFF session cookie vs. passing the SSO token straight to React — is non-blocking (see `9b.2`).
- **Standalone**: this system shares no DB, no auth mechanism, and no repo with the existing Syndome CRM. The only possible overlap is the SSO identity provider itself, if the organization reuses one IdP across systems (unconfirmed).

## Project Conventions

### Code Style

- Request/response bodies are plain JSON. **No `BaseRequest`/`BaseResponse` envelope** (that was a .NET-era convention) — use standard HTTP status codes plus a single error shape `{ error: { code, message, details? } }`. Identity for authorization always comes from the verified SSO session/token, never from a body field (this rule carries forward unchanged from the old system's review R6 — see impact assessment review R6 / B intro).
- DB naming: `snake_case`, no `TM*/TT*` prefix scheme (that was the old SQL-Server-shop convention). Plain descriptive names instead: `status`, `registration`, `entry`, `entry_revision`, etc. New tables for this feature live in a dedicated `project` schema (see the old-name → new-name mapping table in impact assessment `0c`).
- Every table has `id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY` plus audit columns (`created_at, created_by, updated_at, updated_by`). Money columns are `NUMERIC(18,2)`. Text columns default to `TEXT` (Postgres has no perf benefit from `VARCHAR(n)`) unless a format is truly fixed-length (e.g. `project_code VARCHAR(20)`).
- Server recomputes anything the UI calculates for display (totals, GP%, running numbers) — client-side math is preview only, never trusted.

### Architecture Patterns

- UI never talks to the database directly; every screen goes through the React app → Fastify API. API base URL lives in a UI environment variable (e.g. `VITE_API_BASE_URL`).
- Menu/feature visibility mechanism is **not yet designed** — the old system's `dbo.MTControl` + `TempData["rolename"]` pattern has no equivalent to reuse since this system is standalone. Role itself now comes from the SSO JWT `roles` claim (see impact assessment `9c`); a DB-driven menu-visibility toggle on top of that is optional and still undesigned.
- Running numbers (e.g. document codes) are issued by the **API**, never the UI, using a dedicated running-number table updated inside a transaction (`SELECT ... FOR UPDATE` in Postgres) to avoid collisions.
- Where a record can be revised after approval, the accepted pattern is: identity table (stable ID, referenced by other tables) + separate revision table (the actual form data, one row per revision, exactly one flagged current). This pattern is stack-agnostic and unchanged by the re-platform.

### Testing Strategy

- Server-side validation is mandatory for every rule the prototype only enforced in JavaScript (required fields, state transitions, size/type limits) — client-side checks are UX only.
- Acceptance scenarios in this spec (`#### Scenario:` blocks) double as the test scenario list; each should be checkable against a real request/response, not just a UI click-through.

### Git Workflow

- New repos, not yet created — likely UI and API developed/deployed independently as before (mono-repo vs. two repos is still open, see impact assessment `9b.6`), gated on an agreed API contract (this spec) so UI and API work can proceed in parallel against mocks.

## Domain Context

- A **Project** (`project.registration`) can have multiple **Entries** (`project.entry`) — one Entry per sales person who registers a submission for the same underlying project (detected via duplicate-check on org name + project name + dealer). Entry #1 is the original owner; later entries join the same Project.
- Each Entry moves through a 13-state workflow (see `project-status-request`) ending in `won`, `lost`, or `closed`.
- A Project itself has a separate, **derived** status (`open/won/lost/closed`, see `project-lifecycle`) computed from its Entries — it is not something a user sets directly.
- Approval is two-tier for the "won" and "lost (แพ้)" outcomes: team lead (`headsale`) then a Manager role (`salemanager`, Thai nickname "พี่บี") who was pulled into scope for this phase (previously assumed to be a later phase). "ล่ม" (collapse — the project fell through, e.g. budget cut or cancelled) closes the Entry immediately with **no approval step**, unlike a proper loss ("แพ้" — lost to a competitor).
- When a Project has more than one Entry, a Manager designates exactly one as **Leader** (`project.registration.leader_entry_id`) — purely informational, does not change any Entry's workflow state.
- Editing an already-approved Register goes through a **request → draft revision → re-submit → re-approve** cycle, not an in-place edit (see `project-entry-revision`).

## Important Constraints

- **`headsale` and `salemanager` are distinct roles, not reused/merged with any other role** — the original reason ("don't reuse existing CRM roles/tables") is moot now that the system is standalone (there's nothing to accidentally reuse), but the underlying business rule stands: these two roles must stay clearly separated from any other role (e.g. `admin`) to keep the two-tier approval scope correct. Role/permission data lives entirely in the SSO's JWT `roles` claim (no local role table) — this app must ask the SSO admin to configure `group_role_map` for its `client_id` to emit exactly these role strings (see impact assessment `9c`).
- **SYS No. is out of scope.** The original flowchart showed a second numbering scheme ("SYS No.") from another system; the business confirmed this integration is not being built now. The feature uses a single running number, `ProjectCode` (`PRJ-YYYY-MM-XXXX`, reset monthly), issued at creation.
- **Webhook delivery is out of scope** for this phase — only in-app notifications. The notification config table keeps a `WebhookUrl`/`WebhookEnable` column reserved for later, but nothing fires it yet.
- **Cost/GP visibility**: every Sales user can see cost and GP figures for every Entry in the comparison screen (not just their own) — a deliberate, accepted business decision (see `project-entry-comparison`), not an oversight.
- Attachment total size per Entry revision is capped at 10 MB (documents/PDF only); files are renamed on disk to `{ProjectCode}_{TIMESTAMP}_{Seq}` to avoid collisions, original filename preserved for display only.

## External Dependencies

**None at the code/DB level, by design** — as of the 2026-07-21 re-platform this system is fully standalone: no dependency on `syndome-crm-api`, `dbo.MTControl`, `TMRole`, or any other existing-CRM table/endpoint. The one confirmed dependency is identity-level only (SSO, below), never code or DB. Concretely:

- Thai province/district/subdistrict/postal geography data must be sourced fresh (e.g. seeded from an open public dataset) — the old system's lookup API is no longer reused (see impact assessment risk `8.13` / `9b.8`).
- No integration with the existing Quotation module — this is now moot by construction (separate DB, separate codebase), not just a policy decision.
- The **SSO identity provider ("SSO Management") is a confirmed external dependency** — identity/auth-level only, never code or DB level. This app must be registered with the SSO admin (`client_id`/`client_secret`, `redirect_uri`, and a `group_role_map` covering all 4 roles) before auth can work end-to-end (see impact assessment `9c`).
