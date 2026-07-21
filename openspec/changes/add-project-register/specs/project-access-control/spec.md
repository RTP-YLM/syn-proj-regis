## ADDED Requirements

### Requirement: Actor identity is resolved from a verified SSO JWT only
Every Project Register endpoint SHALL determine the calling user's identity and roles from a JWT issued by the org's SSO ("SSO Management", OAuth2 Authorization Code Flow) and verified locally on every request (RS256 signature, `exp`/`iss`/`aud` checks) — identity is the `sub` claim (sAMAccountName), roles are the `roles` claim (an array of app-specific role strings, mapped by the SSO admin via `group_role_map` for this app's `client_id`). No field supplied in a request body SHALL be used to determine identity or role, even if such a field is present in a payload for logging purposes.

#### Scenario: Body-supplied identity field is ignored for authorization
- **WHEN** a request body includes any field naming a user or role different from the verified JWT's `sub`/`roles` claims
- **THEN** the server SHALL authorize the request based solely on the verified JWT, never the body field

#### Scenario: Expired or invalid JWT is rejected before role checks
- **WHEN** a request's JWT has expired, has an invalid signature, or fails `iss`/`aud` verification
- **THEN** the server SHALL reject the request with 401 before evaluating any role or record-level rule

### Requirement: Write endpoints are restricted to the record's owner
Endpoints that create or modify Entry data (save, status-update requests, revision submission, file upload) SHALL succeed only when the acting user's JWT `sub` matches the target Entry's `sale_user_name` (or the user's `roles` include `admin`).

#### Scenario: Sales user cannot modify another Sales user's Entry
- **WHEN** Sales user A calls a write endpoint targeting an Entry owned by Sales user B, by supplying B's Entry ID directly
- **THEN** the server SHALL reject the request with an authorization error, regardless of whether the UI would ever construct such a request

### Requirement: Approval endpoints enforce role and record-level scope together
Approval-list, approve, and reject endpoints SHALL require the caller's `roles` claim to include the role matching the tier being acted on (`headsale` for head-tier transitions, `salemanager` for manager-tier transitions and Leader assignment) **and** SHALL enforce the record-level scope for that role (head: only teams in their `project.team_user` mapping, for both listing and acting; manager: unrestricted).

#### Scenario: Correct role but wrong team is still rejected
- **WHEN** a user whose `roles` include `headsale` (correct role for the transition) calls the approve endpoint for an Entry outside their mapped teams
- **THEN** the server SHALL reject the request — role match alone is not sufficient

#### Scenario: Manager-tier transition rejected for headsale role
- **WHEN** a user without `salemanager` in their `roles` calls the approve endpoint for an Entry in `waitingSupervisorWon` or `waitingSupervisorLost`
- **THEN** the server SHALL reject the request, since that transition is reserved for `salemanager`

### Requirement: Personal-scope read endpoints resolve scope server-side
To-do-list, status-update-list, and notification endpoints SHALL return only the data within the caller's scope (Sales: own Entries; HeadSale: mapped teams' Entries; Manager: all), resolved server-side from the verified JWT — never trusting a scope parameter supplied by the client. The ProjectRegister ALL list, detail, comparison, and revision-history endpoints are **intentionally unscoped reads** — every authenticated role sees every Project, per the accepted cost/GP visibility decision recorded in `project-entry-comparison`.

#### Scenario: Client-supplied scope override is ignored
- **WHEN** a Sales user's to-do-list or status-update-list request includes a parameter attempting to request another user's or team's data
- **THEN** the server SHALL still return only that Sales user's own scope, ignoring the requested override

#### Scenario: ALL list is readable across teams by design
- **WHEN** a Sales user requests the ProjectRegister ALL list
- **THEN** the server SHALL return Projects from every team (subject only to the list's own filters), not just the caller's own scope

### Requirement: Config endpoints are admin-only
Master-data configuration endpoints (team, dealer, competitor brand, org type, lost/collapse reason, notification threshold) SHALL be callable only by a user whose `roles` claim includes `admin`.

#### Scenario: Non-admin cannot write config
- **WHEN** a user whose `roles` include only `headsale` or `salemanager` calls a config-save endpoint
- **THEN** the server SHALL reject the request

### Requirement: New users are auto-provisioned from verified SSO claims
The first time a user's SSO-issued JWT is successfully verified, the system SHALL create (or update) a corresponding `auth.user` row from the JWT's `sub`/`name`/`email`/`roles` claims, for display and audit purposes (e.g. showing an approver's or Entry owner's name). This record is a cache only — it SHALL NOT be consulted for authorization decisions, which always read the current request's JWT directly.

#### Scenario: First login creates a local user record
- **WHEN** a user authenticates via SSO for the first time and calls any endpoint
- **THEN** an `auth.user` row SHALL be created (or updated if already present) with that user's `username`, `display_name`, `email`, and current `roles` snapshot

#### Scenario: Stale cached roles do not grant stale access
- **WHEN** a user's roles changed at the SSO after their last login, and their cached `auth.user.roles` has not yet been refreshed
- **THEN** authorization checks SHALL still use the `roles` claim of the current request's JWT, not the cached value
