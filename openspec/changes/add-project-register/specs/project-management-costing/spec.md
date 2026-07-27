## ADDED Requirements

### Requirement: Project Management table follows the sales team's Excel template
The Project Management (PM) cost/price/GP table SHALL reproduce the structure of the workbook the sales team already fills in (`prototype/Template_ProjectManagement.xlsx`, sheet `หลายรายการ`), not the simplified table in the HTML prototype. Records SHALL be organised in three tiers: a **project summary row** (computed at read time, not stored), **main item** rows (`task_level = 1`), and **spec line** rows (`task_level = 2`) that hold the actual keyed-in numbers. Columns SHALL follow the template's grouping: รายการ, Brand, Model, Q'ty, ต้นทุน (@/Amt.), EP (รายการ/@/Amt.), ราคาขาย (@/Amt.), GP (@/Amt./%), ราคาขายคู่แข่ง (รุ่น/@/Amt.).

#### Scenario: Two-tier entry with a computed summary
- **WHEN** a Sales user enters two main items, each with three spec lines
- **THEN** the system SHALL persist only the main item and spec line rows, and SHALL compute the project summary row from the main items at read time rather than storing it

#### Scenario: Depth is limited to the template's two levels
- **WHEN** a client submits a task row whose `task_level` is greater than 2 or whose parent is itself a spec line
- **THEN** the server SHALL reject the submission

### Requirement: Aggregate fields are auto-calculated and read-only
Every field that is a roll-up SHALL be calculated by the system and SHALL NOT be editable by the user, exactly as the template's formulas behave. On a main item row: `qty` SHALL equal the Qty of its first spec line (it is not a sum, because spec lines are components of the same unit), Brand and Model SHALL show the distinct count of their spec lines' values, and ต้นทุน/EP/ราคาขาย @ and Amt. SHALL be the sum of the spec lines. On the project summary row: Qty and all Amt. columns SHALL be the sum of the main items, while every @ column SHALL be `Amt ÷ Qty` (a weighted unit value, never a sum of unit values). The UI SHALL update every roll-up immediately as the user types, without requiring a calculate action or a save.

#### Scenario: Editing a spec line updates every tier immediately
- **WHEN** a Sales user changes a unit cost on one spec line
- **THEN** that row's amount, its main item's totals, the project summary row, and the Entry totals shown on the comparison view SHALL all reflect the new value without the user saving or pressing any calculate control

#### Scenario: Deleting a spec line reduces the roll-ups
- **WHEN** a Sales user deletes a spec line from a main item
- **THEN** the main item's sums and the project summary row SHALL immediately drop that row's contribution

#### Scenario: Client-supplied aggregates are discarded
- **WHEN** a client submits task rows whose roll-up or GP values disagree with its own line items
- **THEN** the server SHALL discard the submitted aggregates, recompute every derived field itself, and persist only its computed values

#### Scenario: Main item without spec lines is keyed in directly
- **WHEN** a main item has no spec lines at all (a single-line job)
- **THEN** its numeric fields SHALL be directly editable, and adding the first spec line SHALL switch the row to computed mode after warning the user that the keyed-in values will be replaced

### Requirement: Gross Profit deducts EP
GP SHALL be calculated as `ราคาขาย − ต้นทุน − EP` at every tier, and `GP% = GP ÷ ราคาขาย × 100`, matching the template's formulas. The HTML prototype's formula, which omits EP, SHALL NOT be used. `GP @` SHALL be `GP Amt ÷ Qty` of the owning tier. No GP field SHALL be user-editable at any tier.

#### Scenario: EP is subtracted from GP
- **WHEN** an Entry has ราคาขาย 5,100,000, ต้นทุน 2,226,713.70 and EP 160,000 on a main item
- **THEN** that main item's GP SHALL be 2,713,286.30 and its GP% SHALL be 53.20, not the 2,873,286.30 that would result from ignoring EP

#### Scenario: GP fields reject direct edits
- **WHEN** a client submits a GP amount or GP% that it calculated itself
- **THEN** the server SHALL ignore the submitted value and store its own computed figure

### Requirement: Overriding Commission produces two GP figures
An EP line may be an **OC** (Overriding Commission — the commission paid to a Dealer or to a Dealer-side lead; called *Outside Commission* on the Dealer side). Where a main item includes an OC line, the system SHALL produce two GP figures: **GP before OC** (`ราคาขาย − ต้นทุน − EP excluding OC lines`), shown on spec line rows, and **GP after OC** (`ราคาขาย − ต้นทุน − all EP lines`), shown on main item and project summary rows. Where a main item has no OC line the two figures SHALL be equal. Whether an EP line is an OC SHALL be determined solely by the `is_oc` flag on its EP item type, never by matching text in the line's description.

#### Scenario: Two GP figures differ by exactly the OC amount
- **WHEN** a main item carries EP lines of ค่าขนส่ง 10,000 and OC 150,000
- **THEN** the spec line GP (before OC) SHALL exceed the main item GP (after OC) by exactly 150,000

#### Scenario: OC identified by flag, not by wording
- **WHEN** an EP line's description is free text such as `OC 5% N Success` or `Support งาน Sale 1%`
- **THEN** its treatment SHALL follow the `is_oc` flag of the selected EP item type, and text matching SHALL NOT be used to decide it

#### Scenario: GP figures published outside the PM screen
- **WHEN** GP is shown outside the PM table — Entry comparison cards, "best GP" badges, or aggregate statistics
- **THEN** the system SHALL use the GP-after-OC figure as the headline value

### Requirement: Cost and EP prices record their source date
A spec line's unit cost SHALL record the date the quoted cost is valid as of, and an EP line SHALL record the date its price was obtained and the source it came from — the template instructs users to note both in its cell comments (the EP price must come from the logistics team).

#### Scenario: Cost captured with its quotation date
- **WHEN** a Sales user enters a unit cost on a spec line
- **THEN** the system SHALL store the associated cost quotation date alongside it, so a later reviewer can tell how old the costing is

### Requirement: Item names come from the ERP item master
The รายการ/Model values in the PM table SHALL ultimately be selected from the ERP item master rather than typed freely. The integration mechanism is deferred: in this phase the field SHALL remain free text while the record SHALL carry an ERP item code column so that entries created now can be reconciled once the integration exists.

#### Scenario: Free text accepted while the integration is deferred
- **WHEN** a Sales user types an item name that does not correspond to any known ERP item
- **THEN** the system SHALL accept it and leave the ERP item code empty, without blocking the save
