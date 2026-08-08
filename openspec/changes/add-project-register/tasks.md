> ⚠️ **2026-07-21 re-platform note:** this system is now standalone (React + Node.js/Fastify + PostgreSQL + SSO), sharing no code with Syndome CRM. All tasks below reset to not-started — the earlier `[x]` marks reflected UI work already built in the old `.NET`/Razor stack, which is discarded entirely under the re-platform decision (see impact assessment `0c`). Nothing in the new stack has been built yet.

## 1. Database (PostgreSQL, schema `project`)

- [ ] 1.1 Create `project` schema and all master tables: `status`, `dealer`, `running_number`, `team`, `team_user`, `competitor_brand`, `org_type`, `lost_reason`, `collapse_reason`, `ep_item_type` (with `is_oc`, D12), `notification_config`
- [ ] 1.2 Create `registration` (with `project_status`, `leader_entry_id`, normalized org/project-name columns + unique index on the normalized pair, D13)
- [ ] 1.2b Create `registration_revision` (Project-level revision chain, D14) with its own unique-filtered current-revision index
- [ ] 1.3 Create `entry` (identity table) and `entry_revision` (form-data table) with the unique-filtered current-revision index
- [ ] 1.4 Create `entry_file`, `entry_product`, `entry_task` (all child of Revision) — `entry_task` per the Excel template (D12): `task_level` 1–2, `ep_item_type_id`, cost/EP quotation date + source, derived GP columns (before/after OC), `erp_item_code`
- [ ] 1.5 Create `status_request` (with `request_status`, lose/collapse split columns), `approval`, `status_log`
- [ ] 1.6 Create `notification`
- [ ] 1.7 Create `auth.user` (SSO provisioning cache — see `project-access-control`) with the push-channel binding columns `line_user_id` / `telegram_chat_id` (nullable, unique) + `push_channel_pref` (D10)
- [ ] 1.8 Seed master data: 13 `status` rows, `team` (10 teams), `competitor_brand`, `org_type`, `lost_reason` (5), `collapse_reason` (5), `ep_item_type` (ค่าขนส่ง `is_oc=false`, OC `is_oc=true`), `notification_config` (`near_due_days = 90`)
- [ ] 1.9 Add indexes: normalized-name lookups on `registration` (+ `pg_trgm` GIN index for fuzzy search), `entry(project_id)`, `entry(sale_user_name, status_id)`, unique-filtered current-revision index, `notification(target_user_name, is_read)`, `team_user(user_name)`
- [ ] 1.10 Write migration scripts using the chosen ORM's migration tool (Prisma Migrate / Drizzle Kit / node-pg-migrate — see impact assessment `9b.4`, not yet chosen)

## 2. API core (Node.js + Fastify)

- [ ] 2.1 Data-access layer once the ORM is chosen (impact assessment `9b.4`) — models/schema + registration on the DB client
- [ ] 2.2 `ProjectRunning` service: issue `project_code` (`PRJ-YYYY-MM-XXXX`, monthly reset) inside a transaction (`SELECT ... FOR UPDATE`), race-safe
- [ ] 2.3 Duplicate-check service (D13): normalize + exact-match on **org name + project name only** (Dealer is Entry-level, returned as context), `pg_trgm`/`similarity()`-based partial-match warnings, `nextEntrySequence` calculation
- [ ] 2.3b **(new — D12)** PM costing service as a **shared calculation package used by both API and UI**: spec-line → main-item → project-summary roll-ups, `GP = sell − cost − EP`, GP before/after OC driven by `ep_item_type.is_oc`, unit values as `Amt ÷ Qty` at summary level; server recomputes on every save and discards client-supplied aggregates; unit tests assert the figures in `prototype/Template_ProjectManagement.xlsx` (2,863,286.30 / 2,713,286.30 / 5,426,572.60)
- [ ] 2.4 Entry-status state machine service covering all transitions in `project-status-request` (including Reject-returns-to-`presented`, D1)
- [ ] 2.5 Project-status aggregation service (D2): recompute `project_status` on every Entry terminal-state transition, log every change, block new status-update requests once terminal
- [ ] 2.6 Revision service (D4): draft-clone on edit-request-approval, submit-for-reapproval, current/superseded swap in one transaction
- [ ] 2.6b **(new — D14)** Project-revision path: edit topics naming org name / project name / org type open a `registration_revision` instead of an Entry revision; approval re-runs the duplicate check before applying, updates the normalized name columns, applies to every Entry at once, logs at Project scope
- [ ] 2.7 Leader assignment service: single `leader_entry_id` pointer, Manager-only, Project must have >1 Entry
- [ ] 2.8 Notification service: near-due computed query (role-scoped) + `notification` event writer/reader (D5), starting with the collapse ("ล่ม") event
- [ ] 2.9 File service: `@fastify/multipart` receive, `entry_file` row + disk/object-storage write as one operation (backend TBD, `9b.5`), orphan-file sweep job, `{project_code}_{TIMESTAMP}_{Seq}` naming
- [ ] 2.10 Route plugins (one per domain area, e.g. `plugins/project-register/routes.js`): all endpoints from the API contract in `docs/impact-assessment-project-register.md` **Appendix B** (`design.md` carries the data model only, not an endpoint list), each enforcing `project-access-control`'s matrix from the verified SSO JWT only
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
- [ ] 3.4 Create/Edit Register form + duplicate-check modal + Dealer search/add modal — `Amt` in the product box is auto-calculated read-only (`Qty × @`), not a free-typed field as in the prototype
- [ ] 3.4b **(new — D12)** PM table UI per the Excel template: main item / spec line tiers with the template's grey/white visual hierarchy and collapse-expand, every roll-up read-only and recalculating live as the user types (no calculate button, no save required), GP columns never editable, main item with no spec line editable directly then switching to computed mode with a warning on the first spec line
- [ ] 3.5b **(new — D14)** Edit-request form warns, when the chosen topic is org name / project name / org type, that the change will apply to every Entry on the Project including other Sales users'
- [ ] 3.5 File attachment upload UI (multipart via `@fastify/multipart`, per D7) with progress/error display
- [ ] 3.6 Status-update screens: Won form, Lost form with แพ้/ล่ม branch selection, Postpone form, Edit-request form (round 1) + edit-draft form (round 2) — the "แพ้" form gains the structured Lost Reason selector the prototype's live form is missing (both the selector and the free-text analysis are required)
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
- [ ] 5.2 Admin config screens: Team + user↔team matrix, Competitor Brand, Org Type, Lost Reason, Collapse Reason, **EP Item Type (with the `is_oc` flag)**, Notification threshold

## 6. Push notification — LINE / Telegram (`project-push-notification`, D10) — ทำหลัง flow หลักใช้งานได้ครบ

- [ ] 6.1 Decide per channel before starting: which LINE OA (`9b.12`) and its linking mechanism (`9b.13`); which Telegram bot + whether the org permits Telegram (`9b.23`) and how `/start` is received — webhook vs. long-polling (`9b.24`); whether a user may link both at once (`9b.25`); and which event types push at all (`9b.15`)
- [ ] 6.2 Channel-neutral notification payload + dispatch worker: triggered by `project.notification` inserts, runs outside the originating HTTP request, per-channel failure isolated, delivery outcome recorded
- [ ] 6.3 LINE adapter: Flex Message template per event type, `POST /v2/bot/message/push`, deep-link button back into the web app
- [ ] 6.4 Telegram adapter: text (HTML/MarkdownV2) + inline keyboard URL button, `POST /bot{token}/sendMessage`, bot token held as a server-side secret
- [ ] 6.5 Account linking UI + endpoints (`/notification/push/link`, `/unlink`): own-account-only, shows the "not receiving push" state when nothing is linked
- [ ] 6.6 Telegram inbound `/start` handler: one-time expiring token issued by us, secret-token header verified on every webhook call, never binds from a bare `chat_id`
- [ ] 6.7 Content guard: assert on the neutral payload that no cost/EP/GP/price field can reach a message on any channel

## 7. Testing / UAT

- [ ] 7.1 Server-side validation coverage for every field the prototype only validated client-side (required fields on all 4 status-update forms, transition legality, file type/size)
- [ ] 7.2 Walk every scenario in `docs/impact-assessment-project-register.md` Appendix D (D1–D31 and D36–D37 — 33 scenarios; D32–D35 were removed with the AI-chat descope, see `0g` — including SSO auth failure D29, the PM/template calculation scenario D36, and the Project-revision scenario D37) against the real API
- [ ] 7.2b **(new — D12)** Verify the PM table end-to-end against `prototype/Template_ProjectManagement.xlsx`: re-key the template's sample data and assert every tier matches the workbook (GP before OC 2,863,286.30 / GP after OC 2,713,286.30 / summary 5,426,572.60), roll-ups update live while typing, and a hand-tampered aggregate posted to `/save` is overwritten by the server
- [ ] 7.3 Authorization tests: role-level rejection (D13-equivalent) and record-level rejection — Sales A cannot act on Sales B's Entry, a body-supplied identity field is ignored (D28-equivalent)
- [ ] 7.4 Concurrency tests: simultaneous duplicate-check submissions get distinct `entry_sequence`, simultaneous `project_code` issuance doesn't collide
- [ ] 7.5 Auth tests: expired access token triggers refresh, reused/revoked refresh token forces re-login, invalid JWT signature is rejected (D29)
- [ ] 7.6 UAT sign-off with Sales, HeadSale, and Manager roles on a staging environment
