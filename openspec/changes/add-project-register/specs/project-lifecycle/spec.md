## ADDED Requirements

### Requirement: Project status is derived from its Entries
The system SHALL maintain `project.registration.project_status` (`open` / `won` / `lost` / `closed`) as a value computed by the service layer, never set directly by any user action, recalculated whenever any Entry under the Project reaches a terminal EntryStatus (`won`, `lost`, or `closed`).

#### Scenario: Any Entry won means the Project is won
- **WHEN** at least one Entry under a Project reaches `won`
- **THEN** `project_status` SHALL become `won`, regardless of the status of the Project's other Entries

#### Scenario: All Entries terminal with at least one lost
- **WHEN** every Entry under a Project has reached a terminal status (`lost` or `closed`) and at least one of them is `lost`, and none is `won`
- **THEN** `project_status` SHALL become `lost`

#### Scenario: Every Entry closed
- **WHEN** every Entry under a Project has reached `closed` and none has reached `won` or `lost`
- **THEN** `project_status` SHALL become `closed`

#### Scenario: Otherwise remains open
- **WHEN** a Project has at least one Entry not yet in a terminal status, and no Entry has reached `won`
- **THEN** `project_status` SHALL be (or remain) `open`

### Requirement: List and notification data stay keyed on the Entry, not the Project
Despite the derived Project-level status existing, list pages, filters, and notifications SHALL continue to use per-Entry data (team, sales owner, due date) as their primary fields — `project_status` is shown as a supplementary badge, not a replacement for Entry-level fields.

#### Scenario: List row still reflects its own Entry's team and due date
- **WHEN** a Project with multiple Entries on different teams is shown in the ProjectRegister ALL list
- **THEN** each row SHALL show that row's own Entry's team, sales owner, and due date, with the Project's derived status shown alongside as a badge

### Requirement: A terminal Project blocks new status-update requests on its remaining Entries
Once `project_status` reaches `won`, `lost`, or `closed`, the system SHALL reject any new won/lost/postpone/edit request submitted against any of that Project's remaining, non-terminal Entries, and SHALL exclude the whole Project from near-due notifications.

#### Scenario: Status-update rejected after Project is won
- **WHEN** one Entry of a Project has reached `won` and a Sales user on a different, still-`presented` Entry of the same Project submits a new status-update request
- **THEN** the server SHALL reject the request

#### Scenario: Near-due notification stops firing
- **WHEN** a Project's `project_status` becomes terminal
- **THEN** none of its Entries SHALL appear in the near-due notification sweep from that point forward, even if their due dates are still within the configured threshold

### Requirement: Every ProjectStatus change is logged
Each transition of `project_status` SHALL be recorded in `project.status_log` with the previous value, new value, and timestamp.

#### Scenario: Log entry created on transition
- **WHEN** `project_status` changes from `open` to `won`
- **THEN** a log row SHALL be created recording `open → won` for that Project, distinguishable from Entry-level status log rows
