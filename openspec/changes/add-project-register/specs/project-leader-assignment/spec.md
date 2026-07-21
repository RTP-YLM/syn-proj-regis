## ADDED Requirements

### Requirement: Leader assignment restricted to Manager on multi-Entry Projects
Only a `salemanager` (or admin) user SHALL be able to assign a Leader Entry, and only for Projects with more than one Entry.

#### Scenario: Assignment rejected for single-Entry Project
- **WHEN** a `salemanager` user calls the leader-assign endpoint for a Project with only one Entry
- **THEN** the server SHALL reject the request

#### Scenario: Non-Manager role cannot assign
- **WHEN** a `headsale` or Sales user calls the leader-assign endpoint
- **THEN** the server SHALL reject the request regardless of any client-side menu visibility

### Requirement: Leader is a single stable pointer, not a per-Entry flag
The system SHALL record the Leader assignment as a single column, `project.registration.leader_entry_id`, pointing at the stable `project.entry.id` of the chosen Entry — there SHALL NOT be a separate per-Entry "is leader" flag that could disagree with this pointer.

#### Scenario: Leader pointer survives an Entry revision
- **WHEN** the Leader Entry's data is edited through the `project-entry-revision` workflow (new draft revision created, later becomes current)
- **THEN** `project.registration.leader_entry_id` SHALL continue to point at the same Entry, unaffected by which revision is current

### Requirement: Reassigning the Leader moves the pointer, does not alter Entry status
Selecting a different Entry as Leader SHALL update `leader_entry_id` to the new Entry and SHALL NOT change the EntryStatus, ProjectStatus, or visibility of any Entry under the Project.

#### Scenario: Reassignment leaves other Entries untouched
- **WHEN** a `salemanager` user reassigns the Leader from Entry A to Entry B within the same Project
- **THEN** `leader_entry_id` SHALL become Entry B's ID, Entry A's `status_id` SHALL remain exactly as it was, and both Entries SHALL continue to appear in the Project's comparison view exactly as before
