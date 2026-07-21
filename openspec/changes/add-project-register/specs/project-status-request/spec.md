## ADDED Requirements

### Requirement: Status update only available from Presented
An Entry SHALL only accept a new won/lost/postpone/edit status-update request while its EntryStatus is `presented`.

#### Scenario: Update blocked on non-presented Entry
- **WHEN** a status-update request is submitted for an Entry whose status is not `presented`
- **THEN** the server SHALL reject the request, independent of whether the UI's update button was disabled

### Requirement: Won request requires two-tier approval
A "Won" status-update request SHALL require Bid Result data (sales analysis, competitor brand/model/price, inspector, result date — all required) and SHALL pass through `headsale` approval followed by `salemanager` approval before the Entry reaches `won`.

#### Scenario: Full won path
- **WHEN** a Sales user submits a complete Won request from `presented`
- **THEN** the Entry SHALL move to `waitingWon`
- **WHEN** `headsale` approves it
- **THEN** the Entry SHALL move to `waitingSupervisorWon`
- **WHEN** `salemanager` approves it
- **THEN** the Entry SHALL move to `won`, a terminal state

#### Scenario: Incomplete Bid Result rejected server-side
- **WHEN** a Won request is submitted missing any required Bid Result field
- **THEN** the server SHALL reject it even if client-side validation was bypassed

### Requirement: Lost via "แพ้" (competitive loss) requires two-tier approval
A "not won" request where the Sales user selects "แพ้" (lost to a competitor) SHALL require a lost reason, sales analysis, and Bid Result data, and SHALL pass through the same two-tier approval as Won before the Entry reaches `lost`.

#### Scenario: Full lose path
- **WHEN** a Sales user submits a complete "แพ้" request from `presented`
- **THEN** the Entry SHALL move to `waitingLost`, then `waitingSupervisorLost` on `headsale` approval, then `lost` on `salemanager` approval

### Requirement: Lost via "ล่ม" (project collapse) closes immediately without approval
A "not won" request where the Sales user selects "ล่ม" (the project fell through — e.g. cancelled, budget cut, indefinitely postponed, no procurement) SHALL require a collapse reason, collapse date, and note (all required), and SHALL move the Entry directly to `closed` with no approval step.

#### Scenario: Collapse closes immediately
- **WHEN** a Sales user submits a complete "ล่ม" request from `presented`
- **THEN** the Entry SHALL move directly to `closed`, no approval request SHALL be created, and the action SHALL be recorded in the status log with the acting user and timestamp

#### Scenario: Incomplete collapse request rejected
- **WHEN** a "ล่ม" request is missing collapse reason, date, or note
- **THEN** the server SHALL reject the request

### Requirement: Postpone due date requires single-tier approval
A "postpone due date" request SHALL require a new due date and reason, and SHALL be approved or rejected by `headsale` alone.

#### Scenario: Postpone approved applies new date and logs the old one
- **WHEN** `headsale` approves a postpone request
- **THEN** the Entry's due date SHALL be updated to the new value, the previous due date SHALL be recorded in the status log, and the Entry SHALL return to `presented`

### Requirement: Rejecting any status-update request returns the Entry to Presented
When `headsale` or `salemanager` rejects a won/lost/postpone/edit request at any tier, the **request** itself SHALL be marked `rejected` (with a mandatory reason attached to that request), and the **Entry** SHALL return to `presented` — the Entry SHALL NOT enter a terminal `rejected` EntryStatus for this case (that value is reserved for rejection of the initial Register only, per `project-register-approval`).

#### Scenario: Reject at the head tier
- **WHEN** `headsale` rejects a request in `waitingWon`, `waitingLost`, or `waitingPostpone`
- **THEN** the Entry SHALL move to `presented` and the request's `request_status` SHALL become `rejected`

#### Scenario: Reject at the manager tier
- **WHEN** `salemanager` rejects a request in `waitingSupervisorWon` or `waitingSupervisorLost`
- **THEN** the Entry SHALL move to `presented` (not `rejected`) and the Sales owner SHALL be able to submit a new status-update request immediately

#### Scenario: Reject without a reason is refused
- **WHEN** `headsale` or `salemanager` attempts to reject a status-update request without supplying a reason
- **THEN** the system SHALL refuse the rejection until a reason is supplied

#### Scenario: Rejected-request reason is attributed correctly
- **WHEN** a Sales user views the Entry's rejection history after a status-update request was rejected
- **THEN** the reason SHALL be shown attributed to that specific request and approver role, distinguishable from a rejection of the initial Register

#### Scenario: To-do "rejected" summary counts rejected requests
- **WHEN** the to-do-list summary counts are computed for a Sales user after one of their status-update requests was rejected
- **THEN** the "โดน Reject" count SHALL include that rejected request even though the Entry's own status is `presented`

### Requirement: Every Entry status transition is logged
Every EntryStatus transition — including initial approval, every status-update outcome, and the "ล่ม" immediate closure — SHALL be recorded in the status log with the previous status, new status, acting user, timestamp, and, where a request drove the transition, a reference to that request.

#### Scenario: Transition log carries the originating request
- **WHEN** an Entry moves from `waitingWon` to `waitingSupervisorWon` upon `headsale` approval
- **THEN** a status-log row SHALL record `waitingWon → waitingSupervisorWon`, the approver, the timestamp, and the ID of the Won request that drove the transition
