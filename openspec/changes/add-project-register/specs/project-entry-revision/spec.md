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

### Requirement: Edits to Project-level fields revise the Project, not the Entry
Organization name, project name, and organization type belong to the Project header and are shared by every Entry on that Project, so an approved edit request naming one of them SHALL open a **Project-level** draft revision (`project.registration_revision`) rather than an Entry revision. Edit requests naming Dealer, sale conditions, product data, or warranty SHALL continue to open an Entry revision. A Project-level revision SHALL follow the same two-round lifecycle (draft → resubmit → approve → current, prior revision superseded) and SHALL be logged at Project scope.

#### Scenario: Editing the project name opens a Project revision
- **WHEN** `headsale` approves an edit request whose topic is the project name
- **THEN** the system SHALL create a `registration_revision` row in `draft`, SHALL NOT create an Entry revision, and the current project name SHALL remain visible everywhere until the draft is resubmitted and approved

#### Scenario: Approved Project revision applies to every Entry at once
- **WHEN** the second-round approval of a Project-level revision is granted on a Project holding three Entries owned by three different Sales users
- **THEN** the new organization/project name SHALL take effect for all three Entries simultaneously, the Project's normalized name columns SHALL be updated, and the change SHALL be logged at Project scope

#### Scenario: Requester is warned about the shared impact
- **WHEN** a Sales user selects organization name or project name as the topic of an edit request
- **THEN** the UI SHALL state that the change will affect every Entry on the Project, including Entries owned by other Sales users

#### Scenario: Project revision that would collide is rejected at approval
- **WHEN** approving a Project-level revision would make the Project's organization + project name identical to another existing Project
- **THEN** the system SHALL reject the approval, SHALL identify the colliding Project, and SHALL leave the revision in place for correction
