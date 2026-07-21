# Change: Add Project Register / Project Management module

## Why

Sales teams currently have no system to register a prospective project (โครงการ), track its projected cost/price/GP, or route it through management approval before knowing whether it was won. Duplicate submissions for the same project by different sales people are only caught informally. There is no visibility into projects nearing their expected close date, and no record of why a project was rejected or lost. This module (validated against three role-specific HTML prototypes and a flowchart, with 24 open questions closed with the business between 2026-07-17 and 2026-07-19 — see `docs/impact-assessment-project-register.md`) builds that end-to-end: register → duplicate-check → approve → track outcome (won / lost / closed) → compare across sales people bidding the same project.

**2026-07-21 re-platform:** this is now a **standalone system** — React (UI) + Node.js/Fastify (API) + PostgreSQL — sharing no database, auth mechanism, or repo with the existing Syndome CRM. Everything below (business rules, workflow, roles) is unchanged from the original prototype-based design; only the implementation stack changed. See impact assessment `0c` (stack pivot) and `9c` (SSO closure, added 2026-07-21) for the full technical detail.

## What Changes

- **New standalone system, two new roles.** `headsale` (team lead) and `salemanager` (Thai nickname "พี่บี") are app-specific role strings requested from the org's SSO ("SSO Management") via `group_role_map` configured for this app's `client_id` — there is no local role table to insert into; role membership lives entirely at the SSO.
- **Register intake**: Sales creates a Register (project + line-item entry) with a Project Management (PM) cost/price/GP task table, checks for duplicates against org name + project name + dealer, and either starts a new Project or joins an existing one as an additional Entry.
- **Two-tier approval on initial submission**: `headsale` approves the initial Register+PM single-level (`waiting → presented`).
- **Status-update workflow** with four paths from `presented`: Won (2-tier: headsale → salemanager), Lost via "แพ้" — competitive loss (2-tier: headsale → salemanager), Lost via "ล่ม" — project collapse (closes immediately, **no approval**), and Postpone due date (1-tier: headsale). Reject on any status-update request returns the Entry to `presented` (not a terminal `rejected` state) — the request itself carries its own rejected status, separate from the Entry's status.
- **Edit-after-approval as a two-round flow**: approving an edit request opens a draft revision that the Sales owner fills in, which itself must be submitted and re-approved before it becomes the current revision. The prior revision stays viewable read-only.
- **Project-level lifecycle** (`open/won/lost/closed`) derived automatically from the Entries under a Project — no user-settable Project status.
- **Leader designation**: when a Project has more than one Entry, `salemanager` flags exactly one as Leader via a single pointer column — purely informational.
- **List, compare, notify**: a role-scoped list (sort/filter by team, sales person, due date, status), a side-by-side Entry comparison (cost/GP/BOM visible to every Sales user, an accepted risk), near-due (<90 days) notifications scoped by role, and event notifications (starting with the "ล่ม" collapse alert to team lead + all managers).
- **New master data & config**: Team (+ user↔team matrix), Dealer, Competitor Brand, Org Type, Lost Reason, Collapse Reason, Notification threshold — all admin-managed.
- **File attachments**: documents/PDF, ≤10 MB total per Entry revision, uploaded via `@fastify/multipart` directly in the API — no separate JSON/multipart split or MVC-action workaround needed, since Fastify natively accepts multipart requests — renamed on disk with a running suffix to avoid collisions.
- **Auth**: SSO ("SSO Management") via OAuth2 Authorization Code Flow — JWT (RS256) verified locally, roles read from the JWT `roles` claim. Full integration contract (token lifetimes, auto-provisioning, gotchas) is in impact assessment `9c`.
- **Out of scope for this phase**: the second "SYS No." numbering scheme referenced in the original flowchart (a different system, not yet integrated), and actually firing the notification webhook (the config field is reserved but unused).

## Impact

- Affected specs (new capabilities, all `ADDED`):
  - `project-register-intake`
  - `project-register-approval`
  - `project-status-request`
  - `project-entry-revision`
  - `project-leader-assignment`
  - `project-lifecycle`
  - `project-list-sort-filter`
  - `project-entry-comparison`
  - `project-notification`
  - `project-file-attachment`
  - `project-master-data`
  - `project-access-control`
- Affected code:
  - **New API repo** (Node.js + Fastify): route plugins per domain, service layer, PostgreSQL schema `project` (~15 tables, see `design.md`) plus `auth.user` (SSO provisioning cache), migration scripts (ORM/tool not yet chosen — impact assessment `9b.4`), SSO OAuth2 client (callback, token exchange, refresh, logout) and JWT-verification middleware.
  - **New UI repo** (React): pages/components per `screens.md`, design system not yet chosen (impact assessment `9b.7`), API base URL via environment variable.
  - Repo topology (mono-repo vs. two repos) not yet decided — impact assessment `9b.6`.
  - No existing system's code changes at all — this system shares no DB, auth mechanism, or repo with Syndome CRM (the original non-integration decision is now structural, not just policy).
- Estimated effort: ~67–99 person-days (see impact assessment `10` for the current breakdown, which now includes Auth/SSO integration); UI and API can proceed in parallel once this spec is agreed, using mocks against the API contract.
