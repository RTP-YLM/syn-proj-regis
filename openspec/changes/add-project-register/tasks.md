> ⚠️ **2026-07-21 re-platform note:** this system is now standalone (React + Node.js/Fastify + PostgreSQL + SSO), sharing no code with Syndome CRM. All tasks below reset to not-started — the earlier `[x]` marks reflected UI work already built in the old `.NET`/Razor stack, which is discarded entirely under the re-platform decision (see impact assessment `0c`). Nothing in the new stack has been built yet.

## 1. Database (PostgreSQL, schema `project`)

- [ ] 1.1 Create `project` schema and all master tables: `status`, `dealer`, `running_number`, `team`, `team_user`, `competitor_brand`, `org_type`, `lost_reason`, `collapse_reason`, `notification_config`
- [ ] 1.2 Create `registration` (with `project_status`, `leader_entry_id`, normalized org/project-name columns)
- [ ] 1.3 Create `entry` (identity table) and `entry_revision` (form-data table) with the unique-filtered current-revision index
- [ ] 1.4 Create `entry_file`, `entry_product`, `entry_task` (all child of Revision)
- [ ] 1.5 Create `status_request` (with `request_status`, lose/collapse split columns), `approval`, `status_log`
- [ ] 1.6 Create `notification`
- [ ] 1.7 Create `auth.user` (SSO provisioning cache — see `project-access-control`)
- [ ] 1.8 Seed master data: 13 `status` rows, `team` (10 teams), `competitor_brand`, `org_type`, `lost_reason` (5), `collapse_reason` (5), `notification_config` (`near_due_days = 90`)
- [ ] 1.9 Add indexes: normalized-name lookups on `registration` (+ `pg_trgm` GIN index for fuzzy search), `entry(project_id)`, `entry(sale_user_name, status_id)`, unique-filtered current-revision index, `notification(target_user_name, is_read)`, `team_user(user_name)`
- [ ] 1.10 Write migration scripts using the chosen ORM's migration tool (Prisma Migrate / Drizzle Kit / node-pg-migrate — see impact assessment `9b.4`, not yet chosen)

## 2. API core (Node.js + Fastify)

- [ ] 2.1 Data-access layer once the ORM is chosen (impact assessment `9b.4`) — models/schema + registration on the DB client
- [ ] 2.2 `ProjectRunning` service: issue `project_code` (`PRJ-YYYY-MM-XXXX`, monthly reset) inside a transaction (`SELECT ... FOR UPDATE`), race-safe
- [ ] 2.3 Duplicate-check service: normalize + exact-match on org name + project name + dealer, `pg_trgm`/`similarity()`-based partial-match warnings, `nextEntrySequence` calculation
- [ ] 2.4 Entry-status state machine service covering all transitions in `project-status-request` (including Reject-returns-to-`presented`, D1)
- [ ] 2.5 Project-status aggregation service (D2): recompute `project_status` on every Entry terminal-state transition, log every change, block new status-update requests once terminal
- [ ] 2.6 Revision service (D4): draft-clone on edit-request-approval, submit-for-reapproval, current/superseded swap in one transaction
- [ ] 2.7 Leader assignment service: single `leader_entry_id` pointer, Manager-only, Project must have >1 Entry
- [ ] 2.8 Notification service: near-due computed query (role-scoped) + `notification` event writer/reader (D5), starting with the collapse ("ล่ม") event
- [ ] 2.9 File service: `@fastify/multipart` receive, `entry_file` row + disk/object-storage write as one operation (backend TBD, `9b.5`), orphan-file sweep job, `{project_code}_{TIMESTAMP}_{Seq}` naming
- [ ] 2.10 Route plugins (one per domain area, e.g. `plugins/project-register/routes.js`): all endpoints from `design.md`'s data model / the impact assessment's API contract appendix, each enforcing `project-access-control`'s matrix from the verified SSO JWT only
- [ ] 2.11 **(new — SSO/OAuth2 client, see impact assessment `9c`)** Callback route (`GET /auth/callback`): receive `code`+`state`, verify `state`, exchange for tokens via `POST {SSO_BASE_URL}/v1/oauth2/token` (`application/x-www-form-urlencoded`, server-side only)
- [ ] 2.12 **(new)** Session layer: store SSO access/refresh tokens server-side, issue our own httpOnly session cookie to the browser (BFF pattern, recommended — see `9b.2`/`9c`)
- [ ] 2.13 **(new)** Refresh logic: renew the SSO access token via `POST /v1/oauth2/refresh` before its 900s expiry; store the rotated refresh token (single-use — the old one is revoked on use)
- [ ] 2.14 **(new)** Logout endpoint: call `POST /v1/oauth2/logout`, clear the session cookie
- [ ] 2.15 **(new)** JWT-verification `preHandler` hook: verify RS256 signature via the SSO's public key, check `exp`/`iss`/`aud`, read `sub`/`roles` — this is the identity/role source for every endpoint (D6)
- [ ] 2.16 **(new)** Auto-provisioning: upsert `auth.user` from JWT claims (`sub`/`name`/`email`/`roles`) on first successful verification of a session

## 3. UI — Sales screens (React) — layout ทุกจออยู่ใน `screens.md`

- [ ] 3.1 API client setup + `VITE_API_BASE_URL` env var
- [ ] 3.2 ProjectRegister ALL list: server-side paging, sort (team/sales/due date), filter (team/sales/due date/status) — `project-list-sort-filter`
- [ ] 3.3 To-do list with 5 summary cards + filter-by-card
- [ ] 3.4 Create/Edit Register form + PM task table (3-level, auto-calc Amt/GP% client-side, server recomputes) + duplicate-check modal + Dealer search/add modal
- [ ] 3.5 File attachment upload UI (multipart via `@fastify/multipart`, per D7) with progress/error display
- [ ] 3.6 Status-update screens: Won form, Lost form with แพ้/ล่ม branch selection, Postpone form, Edit-request form (round 1) + edit-draft form (round 2)
- [ ] 3.7 Entry comparison page (cost/GP/BOM visible per accepted risk 8.1) — `project-entry-comparison`
- [ ] 3.8 Reject-reason history display, split by approver role (head/supervisor cards)
- [ ] 3.9 Notification bell: merge near-due list + unread `notification` events
- [ ] 3.10 **(new)** Auth layer: "เข้าสู่ระบบ" link/redirect to the login endpoint, protected-route wrapper checking session state, logout button (see impact assessment `9c`/§4.3)
- [ ] 3.11 **(new)** Choose and adopt a design system/component library (impact assessment `9b.7`, not yet chosen) before or alongside building the above

## 4. UI — HeadSale & Manager screens (React)

- [ ] 4.1 Approve Zone to-do cards + approval list (filtered by request type, scoped to headsale's teams via matrix)
- [ ] 4.2 Approval Detail screen: Register+PM view, Entry comparison, approval history, Approve/Reject actions (reject requires reason)
- [ ] 4.3 Manager-only: Supervisor-tier approval list/detail (`waitingSupervisorWon/Lost` only)
- [ ] 4.4 Manager-only: "ระบุ Leader Project" list + detail (compare Entries, assign Leader)

## 5. Menu / Config

- [ ] 5.1 Navigation: Project Register menu group, gated by `headsale`/`salemanager`/admin roles read from the SSO JWT `roles` claim (menu-visibility-from-DB mechanism not yet designed — optional, see `openspec/project.md`)
- [ ] 5.2 Admin config screens: Team + user↔team matrix, Competitor Brand, Org Type, Lost Reason, Collapse Reason, Notification threshold

## 6. Testing / UAT

- [ ] 6.1 Server-side validation coverage for every field the prototype only validated client-side (required fields on all 4 status-update forms, transition legality, file type/size)
- [ ] 6.2 Walk every scenario in `docs/impact-assessment-project-register.md` Appendix D (D1–D29, including the new SSO auth-failure scenario D29) against the real API
- [ ] 6.3 Authorization tests: role-level rejection (D13-equivalent) and record-level rejection — Sales A cannot act on Sales B's Entry, a body-supplied identity field is ignored (D28-equivalent)
- [ ] 6.4 Concurrency tests: simultaneous duplicate-check submissions get distinct `entry_sequence`, simultaneous `project_code` issuance doesn't collide
- [ ] 6.5 Auth tests: expired access token triggers refresh, reused/revoked refresh token forces re-login, invalid JWT signature is rejected (D29)
- [ ] 6.6 UAT sign-off with Sales, HeadSale, and Manager roles on a staging environment
