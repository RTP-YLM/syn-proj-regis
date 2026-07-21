## ADDED Requirements

### Requirement: Single-level approval for the initial Register
The initial Register+Project-Management submission SHALL be approved or rejected by a `headsale` (or admin) user only — there is no Manager/`salemanager` tier for this specific transition, regardless of what any earlier flowchart draft showed.

#### Scenario: HeadSale approves a waiting register
- **WHEN** a `headsale` user approves an Entry in `waiting` status
- **THEN** the Entry SHALL move to `presented` and the transition SHALL be recorded in the approval history with `approver_role = head`

#### Scenario: HeadSale rejects a waiting register with a reason
- **WHEN** a `headsale` user rejects an Entry in `waiting` status without supplying a reason
- **THEN** the system SHALL refuse the rejection until a reason is supplied
- **WHEN** a reason is supplied
- **THEN** the Entry SHALL move to `rejected` and the reason SHALL be visible to the Sales owner on the Entry's detail screen

#### Scenario: salemanager cannot act on the initial-approval tier
- **WHEN** a `salemanager` user calls the approve or reject endpoint for an Entry in `waiting` status
- **THEN** the server SHALL reject the request — this tier belongs to `headsale`/admin only (see `project-access-control`), and the Manager's approval queue SHALL NOT list `waiting` Entries as pending items

### Requirement: Rejected initial Register can be revised and resubmitted
An Entry rejected at the initial-Register tier (EntryStatus `rejected`) SHALL remain editable by its Sales owner and SHALL be resubmittable for approval — `rejected` is a recoverable state for the initial submission, not a dead end.

#### Scenario: Resubmit after initial rejection
- **WHEN** the Sales owner edits a `rejected` Entry and submits it again
- **THEN** the Entry SHALL move to `waiting` and enter the same single-level `headsale` approval as a first submission, with the earlier rejection reason still visible in the Entry's history

### Requirement: Approval scope is limited to the head's configured teams
A `headsale` user SHALL only see and act on Entries belonging to Sales users on teams they are mapped to as head, per the team↔user matrix.

#### Scenario: Head outside the matrix cannot approve
- **WHEN** a `headsale` user calls the approve or reject endpoint for an Entry whose Sales owner is on a team not in that head's `project.team_user` mapping
- **THEN** the server SHALL reject the request regardless of whether the UI would have shown the action
