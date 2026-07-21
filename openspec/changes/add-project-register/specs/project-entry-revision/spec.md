## ADDED Requirements

### Requirement: Edit request approval opens a draft revision, does not apply changes
When `headsale` approves an "edit data" request on a Presented Entry, the system SHALL create a new revision in `draft` status for the Sales owner to fill in. The Entry's **current** revision SHALL remain unchanged and visible everywhere (list, compare, detail) until the draft is itself submitted and approved.

#### Scenario: Approving the edit request does not change visible data
- **WHEN** `headsale` approves an edit request
- **THEN** a new `project.entry_revision` row SHALL be created with `revision_status = draft`, the existing current revision SHALL remain `is_current_revision = true`, and the Entry SHALL return to `presented`

### Requirement: Draft revision must be resubmitted and re-approved before taking effect
The Sales owner SHALL edit only the fields covered by the approved edit request on the draft revision, then submit it for a second round of approval. Only after `headsale` approves this second round does the draft become the current revision.

#### Scenario: Full edit round-trip
- **WHEN** the Sales owner submits the completed draft revision
- **THEN** the Entry SHALL move to `waitingEdit` a second time
- **WHEN** `headsale` approves this submission
- **THEN** the draft revision SHALL become `current` (`is_current_revision = true`), the prior current revision SHALL become `superseded`, and the Entry SHALL return to `presented`

#### Scenario: Second-round rejection keeps the draft open
- **WHEN** `headsale` rejects the resubmitted draft revision
- **THEN** the Entry SHALL return to `presented`, the draft revision SHALL remain `draft` (not discarded), and the Sales owner SHALL be able to edit and resubmit it again

### Requirement: Exactly one current revision per Entry at all times
The system SHALL enforce, at the database level, that each Entry has exactly one revision flagged `is_current_revision = true` at any time (a PostgreSQL unique filtered/partial index); swapping which revision is current SHALL happen inside a single transaction.

#### Scenario: Constraint prevents two current revisions
- **WHEN** any code path attempts to mark a second revision as current for the same Entry without first un-flagging the existing current revision
- **THEN** the unique filtered index SHALL reject the write

### Requirement: Superseded revisions remain viewable read-only
A revision that has been replaced by a newer current revision SHALL remain accessible for viewing (not editing) via the Entry's revision history.

#### Scenario: View revision history
- **WHEN** a user with read access to an Entry opens its revision history
- **THEN** every past revision SHALL be listed with its status (`superseded` or `current`) and SHALL be viewable read-only, including its own snapshot of products, tasks, and files
