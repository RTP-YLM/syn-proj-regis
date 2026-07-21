## ADDED Requirements

### Requirement: Near-due notification is role-scoped
The system SHALL notify users of Entries whose due date is within a configurable threshold (default 90 days), scoped by role: a Sales user sees only their own Entries; a `headsale` user sees Entries of Sales users on their configured teams; a `salemanager` user sees every Entry in the system.

#### Scenario: Sales sees only own Entries
- **WHEN** a Sales user views their notification bell
- **THEN** only near-due Entries they own SHALL appear

#### Scenario: HeadSale sees team Entries via matrix
- **WHEN** a `headsale` user views their notification bell
- **THEN** near-due Entries SHALL be limited to Sales users on teams that head is mapped to in `project.team_user`

#### Scenario: Manager sees every Project
- **WHEN** a `salemanager` user views their notification bell
- **THEN** near-due Entries across every team SHALL appear, unfiltered by team

### Requirement: Near-due notification excludes terminal statuses
An Entry whose status is `won`, `lost`, or `closed`, or whose Project has reached a terminal `project_status`, SHALL NOT appear in the near-due notification list even if its due date falls within the threshold.

#### Scenario: Won Entry stops appearing
- **WHEN** an Entry reaches `won` while still within the near-due threshold
- **THEN** it SHALL no longer appear in any user's near-due notification list from that point on

### Requirement: Near-due threshold is configurable
The number of days considered "near due" SHALL be stored in `project.notification_config` and SHALL be changeable by an admin without a code deployment; every place that computes near-due status SHALL read the current configured value.

#### Scenario: Threshold change takes effect immediately
- **WHEN** an admin changes the threshold from 90 to 60 days
- **THEN** subsequent near-due computations (bell, to-do-list card) SHALL use 60 days without requiring a restart or redeploy

### Requirement: Collapse ("ล่ม") closure creates an event notification
When an Entry is closed via the "ล่ม" path (`project-status-request`), the system SHALL create an event notification targeting the Sales owner's team lead(s) (per the team↔user matrix) and every `salemanager` user.

#### Scenario: Notification created and delivered to the right recipients
- **WHEN** a Sales user closes an Entry via "ล่ม"
- **THEN** a `project.notification` row SHALL be created for each of that Sales user's team lead(s) and for every `salemanager` user, each independently markable as read

#### Scenario: Unread events appear in the bell alongside near-due items
- **WHEN** a recipient with unread event notifications opens the notification bell
- **THEN** the response SHALL include both their unread event notifications and their role-scoped near-due list in the same feed

### Requirement: Event notifications support mark-as-read
A recipient of an event notification SHALL be able to mark it read, independent of other recipients' read state on the same event.

#### Scenario: Marking one recipient's copy read does not affect another's
- **WHEN** one team lead marks their collapse-notification row as read
- **THEN** the corresponding notification row for a `salemanager` recipient of the same event SHALL remain unread until that recipient marks it separately
