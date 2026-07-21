## ADDED Requirements

### Requirement: Team and user↔team matrix are admin-managed
An admin SHALL be able to create/edit Teams and manage a many-to-many user↔team mapping distinguishing `member` and `head` roles within each team; a single user SHALL be able to be a head of more than one team.

#### Scenario: One head mapped to multiple teams
- **WHEN** an admin maps a single user as `head` on two different teams
- **THEN** that user's approval scope (`project-register-approval`) SHALL include Entries from both teams

#### Scenario: Team membership drives visibility in real time
- **WHEN** an admin moves a Sales user from Team A to Team B
- **THEN** that Sales user's existing and future Entries SHALL immediately be visible/approvable to Team B's head(s), not Team A's — access resolves from the current matrix, not a snapshot stored on the Entry

### Requirement: Dealer master supports search and Sales-created temporary dealers
The module SHALL keep its own Dealer master (`project.dealer`, deliberately separate from any other module's dealer tables — there is no other module in this standalone system anyway). Any authenticated user SHALL be able to search it from the Register form; a Sales user SHALL be able to add a temporary dealer (`is_temporary = true`) inline when the dealer is not found, with the creating user recorded.

#### Scenario: Temporary dealer added from the Register form
- **WHEN** a Sales user cannot find their dealer in the search modal and adds one as temporary
- **THEN** the dealer SHALL be created with `is_temporary = true` and the creator recorded from the verified JWT identity, and SHALL be immediately selectable on the form

#### Scenario: Entry revision keeps a dealer snapshot
- **WHEN** an Entry revision is saved referencing a dealer
- **THEN** the revision SHALL store a snapshot of the dealer's name and address as of that save, so later edits to the dealer master do not silently change what the Entry historically displayed

### Requirement: Competitor Brand and Org Type are admin-managed lists
An admin SHALL be able to add, edit, and deactivate Competitor Brand and Organization Type values used in Register and Bid Result forms, without a code deployment.

#### Scenario: New competitor brand appears in the form immediately
- **WHEN** an admin adds a new Competitor Brand value
- **THEN** it SHALL appear as a selectable option in the Bid Result form without any deployment

### Requirement: Lost Reason and Collapse Reason are admin-managed lists
An admin SHALL be able to manage the Lost Reason list (used on the "แพ้" status-update form) and the Collapse Reason list (used on the "ล่ม" status-update form) independently of each other.

#### Scenario: Deactivating a reason removes it from new submissions only
- **WHEN** an admin deactivates a Lost Reason value that has already been used on existing requests
- **THEN** existing requests SHALL continue to display their originally-selected reason, while new submissions SHALL no longer offer the deactivated value

### Requirement: Notification threshold is configurable, webhook fields reserved but inactive
An admin SHALL be able to configure the near-due notification threshold (in days). The configuration SHALL include `webhook_url` and `webhook_enable` fields for future use, but no code in this phase SHALL dispatch anything to that URL.

#### Scenario: Enabling the webhook flag has no dispatch effect in this phase
- **WHEN** an admin sets `webhook_enable = true` and supplies a `webhook_url`
- **THEN** the system SHALL persist the values but SHALL NOT make any outbound HTTP call as a result, since webhook dispatch is out of scope for this phase
