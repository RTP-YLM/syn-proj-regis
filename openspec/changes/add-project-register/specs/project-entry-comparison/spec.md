## ADDED Requirements

### Requirement: Compare page shows all Entries' Register data for a Project
For any Project with more than one Entry, the system SHALL provide a comparison view showing each Entry's Register data (organization, sales owner, team, dealer, due date, etc.) side by side.

#### Scenario: All Entries listed regardless of status
- **WHEN** a Project has Entries in `draft`, `waiting`, and `presented` status
- **THEN** the Register-data comparison table SHALL show all of them, including the not-yet-approved ones

### Requirement: Project Management comparison restricted to eligible statuses
The cost/price/GP (Project Management) comparison and BOM comparison SHALL only include Entries whose status is in the eligible set: `presented, waitingPostpone, waitingEdit, waitingWon, waitingLost, waitingSupervisorWon, waitingSupervisorLost, won, lost, closed` — i.e. Entries that have passed initial Register+PM approval.

#### Scenario: Draft or pending Entry excluded from PM comparison
- **WHEN** a Project has one Entry in `draft` and one Entry in `presented`
- **THEN** the PM/cost/GP comparison SHALL show data only for the `presented` Entry, while the Register-data comparison still shows both

### Requirement: Cost and GP figures are visible to every Sales user
Every Sales user, not only the Entry's owner, SHALL be able to view cost, EP, sell price, and GP figures for every eligible Entry in the comparison view — this is a deliberate business decision, not a gap.

#### Scenario: Sales user views another Entry's cost/GP
- **WHEN** a Sales user who does not own any Entry on a Project opens that Project's comparison page
- **THEN** the response SHALL include cost, EP, sell price, and GP fields for every eligible Entry, not just Entries the viewer owns

#### Scenario: Comparison page view is audit-logged
- **WHEN** any user opens a Project's comparison page
- **THEN** the system SHALL record an audit log entry identifying the viewer, the Project, and the timestamp

### Requirement: Entry totals come from the Project Management summary
The cost, EP, sell price, and GP totals shown per Entry SHALL be the project summary figures defined in `project-management-costing` — summed from that Entry's main items only, never from its spec lines, so component rows are not counted twice. The GP shown SHALL be the GP-after-OC figure.

#### Scenario: Spec lines are not double-counted
- **WHEN** an Entry has two main items, each holding three spec lines
- **THEN** its comparison totals SHALL equal the sum of the two main items, not the sum of all eight rows

#### Scenario: Comparison GP accounts for Overriding Commission
- **WHEN** an Entry carries an OC line on one of its main items
- **THEN** the GP figure shown for that Entry in the comparison SHALL be the GP after deducting the OC

### Requirement: Equal figures across Entries are marked equally
Where two or more Entries share the same lowest cost, lowest sell price, highest GP, or best GP%, the system SHALL mark every Entry holding that value, with no tie-breaking rule that picks a single winner — different Dealers quoting identical figures is a normal outcome.

#### Scenario: Two Entries tie on best GP
- **WHEN** two eligible Entries have exactly the same GP amount and it is the highest on the Project
- **THEN** both SHALL carry the "highest GP" marker
