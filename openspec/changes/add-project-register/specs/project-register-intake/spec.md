## ADDED Requirements

### Requirement: Create Register as draft
Sales SHALL be able to create a new Register (Project header + one Entry + Project Management task table) and save it as `draft` before submitting for approval. A draft is editable by its owner and is not visible to any approver.

#### Scenario: Save incomplete Register as draft
- **WHEN** a Sales user saves a Register with some required fields still empty
- **THEN** the system SHALL save it with `status_id` pointing at the `draft` status and SHALL NOT reject the save or route it to any approver

#### Scenario: Submit requires Register and PM complete
- **WHEN** a Sales user submits a Register for approval (`draft → waiting`)
- **THEN** the server SHALL validate that all required Register fields and at least one Project Management task row are present, and SHALL reject the submission with field-level errors if not — independent of any client-side validation already performed

### Requirement: Duplicate check before creating a new Project
Before a new Project is created, the system SHALL check the submitted organization name and project name against existing Projects, using normalized comparison (trim, lowercase, collapsed whitespace). Those two fields alone SHALL identify a Project. Dealer SHALL NOT take part in the match, because the business is B2B and several Dealers routinely request pricing for the same job — that is precisely why a Project holds multiple Entries, each with its own Dealer.

#### Scenario: Exact match on organization and project name
- **WHEN** organization name and project name both match an existing Project after normalization
- **THEN** the system SHALL report the match as an exact duplicate and SHALL offer submitting as a new Entry under that Project instead of creating a new Project

#### Scenario: A different Dealer on the same job is still the same Project
- **WHEN** the submitted organization and project name match an existing Project but the Dealer differs from every Entry already on it
- **THEN** the system SHALL still report an exact duplicate and offer joining as a new Entry, and SHALL NOT let the difference in Dealer produce a second Project for the same job

#### Scenario: Partial match warns but does not block
- **WHEN** only one of the two fields matches an existing Project after normalization
- **THEN** the system SHALL show the partial matches as a warning, including a `pg_trgm`/`similarity()`-based supplementary search for near-matches, and SHALL list the Dealers already attached to each matched Project for context, but SHALL still allow creating a new Project

### Requirement: Join an existing Project as a new Entry
When a Sales user confirms an exact duplicate match, the system SHALL let them submit a new Entry under the existing Project rather than duplicating the Project.

#### Scenario: Next entry sequence assigned correctly
- **WHEN** a Sales user submits a new Entry under an existing Project
- **THEN** the system SHALL assign it the next `entry_sequence` for that Project and an `entry_code` of the form `{project_code}-E{sequence}`

#### Scenario: Concurrent join submissions do not collide
- **WHEN** two Sales users submit a new Entry under the same Project at the same time
- **THEN** the system SHALL assign each a distinct `entry_sequence` with no duplicate, using a transaction and a `UNIQUE (project_id, entry_sequence)` constraint as the source of truth — not a value computed and trusted from the client

### Requirement: Project code issuance
The system SHALL issue a unique `project_code` in the format `PRJ-YYYY-MM-XXXX` when a new Project is created, with the running number resetting to `0001` at the start of each calendar month.

#### Scenario: Sequence resets on a new month
- **WHEN** the first Project of a new calendar month is created
- **THEN** its `project_code` sequence number SHALL be `0001` for that year/month, independent of the previous month's ending number

#### Scenario: Concurrent creation does not collide
- **WHEN** two Projects are created at the same time within the same month
- **THEN** the system SHALL issue each a distinct sequence number using a transaction-protected running-number table, never client-supplied

### Requirement: Project Management task table is required to submit
Every Entry SHALL carry a Project Management cost/price/GP table, whose structure, columns, formulas, and calculation rules are specified in `project-management-costing`. An Entry SHALL NOT be submittable for approval without at least one main item on that table.

#### Scenario: Submission without any PM main item is rejected
- **WHEN** a Sales user submits a Register whose Project Management table has no main item row
- **THEN** the server SHALL reject the submission and SHALL keep the Entry in `draft`
