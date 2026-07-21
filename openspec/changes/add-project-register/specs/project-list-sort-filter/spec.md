## ADDED Requirements

### Requirement: ProjectRegister ALL list supports server-side sort
The ProjectRegister ALL list SHALL support sorting by team, sales owner, or due date, ascending or descending, computed server-side (not client-side) so results remain correct across paginated pages.

#### Scenario: Sort by due date ascending across pages
- **WHEN** a user sorts the list by due date ascending and navigates to page 2
- **THEN** page 2's rows SHALL continue the same overall due-date ordering as page 1, computed by the server for the full result set, not just the rows already loaded in the browser

### Requirement: ProjectRegister ALL list supports combinable filters
The list SHALL support filtering by team, sales owner, due date, and status simultaneously, combinable with the existing text search, all applied server-side.

#### Scenario: Combined filter narrows correctly
- **WHEN** a user filters by team = "Team A" and status = "presented" at the same time
- **THEN** the returned rows SHALL satisfy both conditions simultaneously

#### Scenario: Clear-filter resets every filter field
- **WHEN** a user has team, sales, due-date, and status filters all set and clicks "ล้าง Filter"
- **THEN** every filter field SHALL reset to its default (unfiltered) state and the list SHALL show the unfiltered result set

### Requirement: List shows Entry count per Project
Each Project's row (or the grouping the list uses) SHALL show the number of Entries under that Project, computed via an aggregate query, not an N+1 per-row lookup.

#### Scenario: Entry count reflects actual Entries
- **WHEN** a Project has 3 Entries
- **THEN** the list SHALL show "3" for that Project's Entry count
