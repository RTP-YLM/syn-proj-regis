> UI screen layouts (wireframe ทุกจอ + mapping จอ×role×endpoint) อยู่ที่ `screens.md` ในโฟลเดอร์เดียวกัน

## Context

New two-part module (React UI + Fastify API — repo topology mono vs. split not yet decided, see impact assessment `9b.6`) with a non-trivial state machine (13 Entry states across 2 approval tiers), a Project/Entry/Revision data model, and a derived Project-level status. The design went through several rounds: an initial pass against the HTML prototypes + flowchart (closing 21 open questions), an independent design review that surfaced 8 structural gaps (R1–R8 below, closed with 3 more decisions, 9.22–9.24), a full tech-stack re-platform to React + Node.js/Fastify + PostgreSQL + SSO (standalone from Syndome CRM), and a closure of the SSO/auth open questions (9b.1–9b.3) against a concrete SSO integration guide. This file captures the resulting technical shape; the full narrative — prototype-by-prototype comparison, every open question and answer, the DDL draft, API contract draft, field mapping, and 29 acceptance scenarios — lives in `docs/impact-assessment-project-register.md` and should be treated as the detailed backing reference for everything summarized here.

## Goals / Non-Goals

**Goals:**
- One coherent state model per Entry (13 states) that Reject can always recover from without creating dead ends.
- A Project-level status that's genuinely derived, never independently editable, so it can't drift from its Entries.
- An edit workflow where "approved" and "has unreviewed changes" are never the same state.
- A revision model where "which Entry does this belong to" is unambiguous even mid-edit, so Leader assignment and every other Entry-ID reference stays valid across revisions.
- Every endpoint's authorization decided by a verified SSO JWT only, with a written record-level rule, not implied by which menu item calls it.

**Non-Goals:**
- SYS No. (second numbering scheme) integration — explicitly deferred, not designed here.
- Webhook delivery — config field reserved, no dispatch logic in this phase.
- Fuzzy/approximate duplicate matching — Phase 1 duplicate-check is exact-match on normalized fields only; `pg_trgm`/`similarity()`-based partial-match warnings are included, true fuzzy matching is future work.
- Multi-Manager load balancing / assignment — role structure supports more than one `salemanager` user, but no routing logic beyond "any salemanager can act."
- Choosing the ORM, UI design system, attachment storage backend, or hosting/CI-CD target — tracked as open in impact assessment `9b`, not blocking this spec.

## Decisions

### D1 — Entry status vs. Request status are two different state machines

**Problem (review R1):** The prototype sent every rejected status-update request (won/lost/postpone/edit) to a terminal `rejected` Entry status, with no defined way back — the only outgoing transition from `waiting` (initial register) is to `presented`, so a Reject on, say, `waitingSupervisorWon` had no valid recovery path.

**Decision:** Split into two independently-tracked statuses:
- **EntryStatus** (`project.status`, 13 values) — the Entry's own workflow position. `rejected` in this state machine now means only "the *initial* Register was rejected" (`waiting → rejected`).
- **RequestStatus** (on `project.status_request`) — the status of a single won/lost/postpone/edit request. When headsale or salemanager rejects a request, `request_status = rejected` (with the reason attached to that request) and the **Entry returns to `presented`**, immediately eligible for a new status-update request.

This is a strictly additive clarification over the original 13-state list — no new EntryStatus values were added.

### D2 — Project-level lifecycle is derived, not stored-and-set

**Problem (review R2):** The prototype and flowchart only ever talk about Entry status ("won", "closed" language used loosely), but a Project can have several Entries in different states at once. Nothing said what "the Project's status" means when Entries disagree.

**Decision:** Add `project.registration.project_status` (`open` / `won` / `lost` / `closed`), computed by the service layer every time any Entry under the Project reaches a terminal state — never set directly by a user action:

| ProjectStatus | Condition (evaluated top-down) |
|---|---|
| `won` | at least one Entry is `won` |
| `lost` | every Entry is terminal (`lost`/`closed`) and at least one is `lost` |
| `closed` | every Entry is `closed` |
| `open` | anything else (default) |

List pages, filters, and notifications still key off **Entry**-level data (team/sales/due date belong to the Entry, per the prototype) — `project_status` is a supplementary badge. Once a Project reaches a terminal status, the service rejects any further status-update request on its remaining Entries and the Project drops out of near-due notifications. Every `project_status` transition is logged.

### D3 — Editing an approved Register is a two-round approval, not an in-place patch

**Problem (review R3):** Two irreconcilable descriptions existed: the state-machine table said an approved edit request applies immediately, while the earlier decision (closing question 9.13) said the approval opens a revision for the Sales owner to fill in themselves — leaving unresolved whether *that* edit then needs its own approval.

**Decision:** Two distinct rounds, no new EntryStatus values (both rounds reuse `waitingEdit`):
1. Sales requests an edit (`presented → waitingEdit`) → headsale approves the *request* → service clones a **draft** revision (`revision_status = draft`) for the Sales owner to fill in. The **current revision is untouched** — nothing customer-facing changes yet, Entry returns to `presented`.
2. Sales edits the draft and submits it (`presented → waitingEdit`, second round, same status value) → headsale approves the *revision* → the draft becomes `current` (`is_current_revision = true`), the previous current becomes `superseded` (read-only), Entry returns to `presented`.

Rejecting either round returns the Entry to `presented` (D1) and leaves the draft revision open for another attempt (round 2) or discards the un-started request (round 1).

### D4 — Entry identity is separate from Entry form data (revision split)

**Problem (review R4):** The original single-table revision design (one entry table with `revision_no`/`is_current_revision` columns, a new row per revision) meant an Entry's "identity" changed row on every edit. That collided with two other requirements: the Project's `leader_entry_id` needs a stable target to point at across edits, and nothing enforced "exactly one current revision per Entry" as an actual constraint.

**Decision:** Split into:
- `project.entry` — one row per Entry, **for its entire life**. Holds identity (`project_id`, `entry_sequence`, `entry_code`), ownership (`sale_user_name`), and the EntryStatus (`status_id`). This is what `leader_entry_id` and every other cross-table reference points at.
- `project.entry_revision` — one row per revision of that Entry's form data (team, dealer, sale condition, due date, warranty, etc.), with `revision_status` (`draft`/`waiting`/`current`/`superseded`) and a **unique filtered index** enforcing exactly one `is_current_revision = true` row per Entry. Files/Products/PM-tasks are children of the Revision, not the Entry, and get cloned when a new revision is created. Swapping current↔superseded happens inside one transaction.

Leader assignment (`project-leader-assignment`) then simply stores `project.registration.leader_entry_id` pointing at the stable Entry — no separate "is leader" flag needed on the Entry or Revision table; it's redundant with a single FK.

### D5 — Event notifications need their own table, separate from near-due notifications

**Problem (review R5):** Acceptance criterion D22 ("notify head/Manager when a project is closed via ล่ม") had no backing design — the only notification concept designed was the near-due (<90 days) sweep, which is a *computed* list (query over due dates), not a stored event.

**Decision:** Add `project.notification` — one row per (event, recipient) pair with `is_read`/`read_date`. First event type is `collapseClosed`, fired when an Entry is closed via "ล่ม", targeting the Sales owner's team lead(s) (via the team↔user matrix) and every `salemanager` user. The bell icon merges this table's unread rows with the near-due computed list. The table is typed (`notify_type`) so later event types (e.g. "approved", "rejected") can reuse it without a schema change.

### D6 — Authorization is verified-SSO-JWT-only, with a written per-endpoint matrix

**Problem (review R6):** Only the approval endpoints had an explicit role check documented; nothing said whether, e.g., Sales A could edit Sales B's Entry by guessing its ID, or whether the server trusts a client-supplied identity field from the request body.

**Decision:** `project-access-control` spec defines, per endpoint group: which roles can call it, and the record-level rule (e.g. "only the Entry's own `sale_user_name`", "only teams in the caller's `project.team_user` mapping"). The identity used for every such check is a JWT issued by the org's SSO ("SSO Management", OAuth2 Authorization Code Flow) and verified locally on every request (RS256, public key) — the `sub` claim (sAMAccountName) is identity, the `roles` claim (an array of app-specific role strings, mapped by the SSO admin via `group_role_map` for this app's `client_id`) is authorization. No field supplied in a request body is ever used for identity or role — this is a stricter continuation of the original principle (there is no `BaseRequest`/`LoginUserName`-style envelope in the new API at all, so there is no such field to guard against by convention, only by discipline in any ad-hoc payload). Full protocol detail — token lifetimes, refresh rotation, the recommended BFF pattern for the React↔Fastify boundary, and integration gotchas — is in impact assessment `9c`.

### D7 — File upload is multipart, directly on the API, no framework workaround needed

**Problem (original, .NET-era):** The old stack's `/save` was JSON-only (matching `HttpRequestHelper`, which only spoke `application/json`), forcing attachments through a separate MVC-action indirection. Also, the originally-proposed disk filename (`{ProjectCode}_{TIMESTAMP}` down to the second) collides if two files are uploaded in the same second.

**Decision:** Fastify's `@fastify/multipart` accepts multipart form data natively, in the same API tier as everything else — **no UI-side action or separate framework hop is needed**, unlike the old stack. Sequencing stays the same regardless: create/update the Entry+Revision first (via the JSON endpoint, so file rows have a Revision ID to attach to), then upload files against that ID via the multipart endpoint. The API writes both the `project.entry_file` row and the disk (or object-storage — backend not yet chosen, see impact assessment `9b.5`) write inside the same operation (metadata write failing rolls back the file write and vice versa; a periodic job sweeps orphans). Disk/object filenames get a running suffix: `{project_code}_{TIMESTAMP}_{Seq}.{ext}`.

### D8 — One canonical table-naming set

**Problem (review R8, original):** Earlier drafts of this feature used two different naming schemes in different sections from iterating on the doc over several days.

**Decision:** The names used throughout this spec and its DDL are the PostgreSQL `snake_case` set defined in impact assessment `0c`/Appendix A (`project.status`, `project.registration`, `project.entry`/`project.entry_revision`, `project.status_request`, `project.approval`, `project.status_log`, `project.notification`, `lost_reason_id`, plus `auth.user` for SSO provisioning) — no other table/column name variants (old PascalCase or otherwise) should be reintroduced. The impact assessment's `0c` section has the full old-name → new-name mapping for anyone cross-referencing the pre-pivot history in its `0`/`0b`/`9` sections.

## Data Model Summary

All tables live in a new `project` schema, except `auth.user` (SSO provisioning cache). `BIGINT GENERATED ALWAYS AS IDENTITY` PK + standard audit columns on every table unless noted.

| Table | Kind | Purpose |
|---|---|---|
| `project.status` | Master | 13 Entry-level workflow states + display order + badge style |
| `project.dealer` | Master | Dealer records for this module (name, address, province/district/subdistrict/postal, `is_temporary`) |
| `project.running_number` | Master | `project_code` sequence (`PRJ`, year, month, current no.) — reset monthly |
| `project.team` / `project.team_user` | Master | Sales teams + user↔team matrix (member/head roles, 1-to-many head↔team) |
| `project.competitor_brand` / `project.org_type` | Master | Config lists, admin-managed |
| `project.lost_reason` / `project.collapse_reason` | Master | Config lists for the two "not won" sub-flows |
| `project.notification_config` | Master | Near-due day threshold (default 90) + reserved webhook fields |
| `project.registration` | Trans header | One row per Project: `project_code` (unique), org/project name (+ normalized columns for duplicate-check), org type, `project_status` (derived, D2), `leader_entry_id` (D4) |
| `project.entry` | Trans | Entry identity — one row per Entry for its whole life (D4): sequence, code, owner, `status_id` |
| `project.entry_revision` | Trans | Entry form data per revision (D4): team, dealer, sale condition, due date, warranty, `revision_status`, unique-filtered current flag |
| `project.entry_file` | Trans | Attachments, child of Revision |
| `project.entry_product` | Trans | Product lines, child of Revision |
| `project.entry_task` | Trans | PM cost/price/GP task tree (≤3 levels), child of Revision |
| `project.status_request` | Trans | Won/lost/postpone/edit requests: type, payload, `request_status` (D1), lose/collapse split fields |
| `project.approval` | Trans | Approval history: approver, role (head/supervisor), action, reason |
| `project.status_log` | Trans | Every EntryStatus **and** ProjectStatus transition (D2), old due-date-on-postpone history |
| `project.notification` | Trans | Event notifications (D5): type, recipient, read state |
| `auth.user` | Master (auth) | SSO auto-provisioning cache — `username` (=JWT `sub`), `app_username`, `display_name`, `email`, `roles` snapshot; display/audit only, never consulted for authorization (see `project-access-control`) |

## Effort Estimate

~67–99 person-days (DB design 3–4, API core + state machine 10–14, revision versioning 3–5, Project-lifecycle aggregation 1–2, event notification 2–3, UI list/register/PM/compare/status-update/approval/Manager screens ~24–34, config screens 3–5, in-app notification wiring 2–3, design system from scratch 2–4, Auth/SSO integration 6–9, integration testing/UAT 7–10) — roughly 10–12 calendar weeks with 2 people working UI/API in parallel, **not counting** ramp-up time if the team is unfamiliar with React/Node/Fastify/PostgreSQL (impact assessment risk `8.12`, still unconfirmed). Full per-line breakdown and revision history of this estimate: `docs/impact-assessment-project-register.md` §10.

## Risks / Trade-offs

- **Cost/GP visible to every Sales user** (accepted business decision, not mitigated by hiding data) → mitigated by audit-logging every comparison-page view and keeping the response shape easy to strip cost/GP fields later if policy changes.
- **"ล่ม" closes a Project with zero approval** → mitigated by required-field validation (reason/date/detail), full audit log of who/when, the D5 event notification to team lead + all managers, and a monthly collapsed-projects report; a headsale approval gate for "ล่ม" was considered and explicitly rejected to match the flowchart's "= End" intent.
- **Two-tier approval adds lead time**; a single unavailable `salemanager` user stalls every `waitingSupervisor*` Entry system-wide → mitigated by a clearly visible "stuck" queue on the Manager dashboard and the role design already supporting more than one `salemanager` account (no schema change needed to add a second one).
- **Revision-table split (D4) adds join complexity** to every read query (list/detail/compare must always join to the current revision) → mitigated by the mandatory unique-filtered index making "find the current revision" a single indexed lookup, never a scan.
- **Standalone delivery** — nothing to reuse from Syndome CRM, including auth — mitigated by freezing this spec plus the impact assessment's `9c` SSO contract before implementation starts, and developing UI/API against mocks in parallel.
- **Single external dependency (SSO)** — if Active Directory/LDAP is down, no one can log in anywhere in the org, not just this app; this app cannot mitigate that itself (impact assessment risk `8.11`).

## Migration Plan

Purely additive — brand-new standalone system, nothing existing to modify. Rollout order:
1. Provision the PostgreSQL schema `project` (+ `auth.user`) via the chosen ORM's migration tooling (impact assessment `9b.4`); seed master data (13 statuses, 10 teams, competitor brands, org types, lost/collapse reasons, `notification_config` default).
2. Register this app with the SSO admin — `client_id`/`client_secret`, `redirect_uri`, and a `group_role_map` covering all 4 roles (`sales`/`headsale`/`salemanager`/`admin`) — see impact assessment `9c`.
3. Ship the Fastify API behind the endpoints in the impact assessment's API contract (Appendix B), including the SSO OAuth2 client and JWT-verification middleware.
4. Ship the React UI once the API contract is stable; can develop against mocks before the API ships.
5. No data backfill required (greenfield feature — impact assessment `9b.10` is still open on whether any legacy data, e.g. existing Dealer records, should be imported; current assumption is a fully empty starting database).
6. Rollback is drop-the-schema / de-register the app from SSO — no shared table, auth mechanism, or system is touched, so nothing else is at risk.

## Open Questions

All 24 **business** questions from the impact assessment are closed (unchanged by the re-platform), and the 3 SSO/auth questions (9b.1–9b.3) are now closed as of 2026-07-21 — see impact assessment `9c`. Still genuinely open, tracked in impact assessment `9b`: ORM choice (`9b.4`), attachment storage backend (`9b.5`), repo topology (`9b.6`), UI design system (`9b.7`), Thai geography data source (`9b.8`), hosting/CI-CD target (`9b.9`), legacy-data migration (`9b.10`) — none of these block this spec further, only implementation start. Two items remain explicitly deferred out of scope rather than open: SYS No. integration and webhook dispatch (see Non-Goals).
