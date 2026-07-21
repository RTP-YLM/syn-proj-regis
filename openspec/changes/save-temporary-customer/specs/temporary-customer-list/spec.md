## ADDED Requirements

### Requirement: User can view temporary customers
The system SHALL allow users to view all temporary customer records they have created.

#### Scenario: Access temporary customer list
- **WHEN** user navigates to the temporary customer list (via menu or link)
- **THEN** the system displays all temporary customers with their basic information (name, contact, date created)

#### Scenario: Filter temporary customers
- **WHEN** user views the temporary customer list
- **THEN** the user can filter by customer name, creation date, or other relevant criteria

#### Scenario: Empty list message
- **WHEN** there are no temporary customers to display
- **THEN** the system shows a message indicating "No temporary customers found"

### Requirement: User can resume editing temporary customer
The system SHALL allow users to resume editing a temporary customer record.

#### Scenario: Open temporary customer for editing
- **WHEN** user clicks on a temporary customer record in the list
- **THEN** the system loads that customer's data into the form for editing

#### Scenario: Save changes to temporary customer
- **WHEN** user edits a temporary customer and clicks "Save" button
- **THEN** the system updates the temporary customer record with the new data

#### Scenario: Convert temporary to permanent
- **WHEN** user finishes editing a temporary customer and completes all required fields then clicks "Save Customer" (not "Save as Temporary")
- **THEN** the system changes the customer status from "Temporary" to "Active" and stores it as a permanent customer record

### Requirement: User can delete temporary customer
The system SHALL allow users to delete temporary customer records.

#### Scenario: Delete temporary customer
- **WHEN** user selects a temporary customer and clicks "Delete" button
- **THEN** the system displays a confirmation dialog asking "Are you sure?"

#### Scenario: Confirm deletion
- **WHEN** user confirms deletion in the dialog
- **THEN** the system deletes the temporary customer record and removes it from the list

#### Scenario: Cancel deletion
- **WHEN** user cancels deletion in the confirmation dialog
- **THEN** the deletion is cancelled and the customer remains in the list

