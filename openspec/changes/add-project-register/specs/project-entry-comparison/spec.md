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
