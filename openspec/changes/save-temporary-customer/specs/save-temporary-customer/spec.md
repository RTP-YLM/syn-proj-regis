## ADDED Requirements

### Requirement: User can save customer as temporary
The system SHALL allow users to save customer information as a temporary record without completing the full customer creation workflow.

#### Scenario: Save customer with required fields
- **WHEN** user fills in required customer fields and clicks "Save as Temporary Customer" button
- **THEN** the system saves the customer data with temporary status and returns the customer ID

#### Scenario: Save customer with partial data
- **WHEN** user saves customer data with some optional fields empty
- **THEN** the system saves the customer data with whatever fields were provided (does not require all fields)

#### Scenario: Validation errors on temporary save
- **WHEN** user attempts to save without required base fields (name, contact info) and clicks "Save as Temporary"
- **THEN** the system displays validation errors and does not save the record

#### Scenario: Successful save feedback
- **WHEN** temporary customer is successfully saved
- **THEN** the system displays confirmation message "Customer saved temporarily" with customer ID and offers to continue editing or view list

### Requirement: Temporary customer has distinct status
The system SHALL store temporary customers with a distinct status that differentiates them from permanent customer records.

#### Scenario: Status set on creation
- **WHEN** a temporary customer is created via CreateTemporary action
- **THEN** the customer record is stored with Status = "Temporary"

#### Scenario: Status distinguishes in queries
- **WHEN** querying customer records
- **THEN** temporary customers are retrievable separately using Status filter or can be explicitly included/excluded

### Requirement: Button appears in customer form
The system SHALL display a distinct "Save as Temporary Customer" button in the customer entry interface.

#### Scenario: Button visible in form
- **WHEN** user views the customer form (in Expense or Quotation workflow)
- **THEN** a secondary-styled button labeled "Save as Temporary Customer" is visible alongside the main "Save" button

#### Scenario: Button calls correct endpoint
- **WHEN** user clicks "Save as Temporary Customer" button
- **THEN** the client calls POST /Customer/CreateTemporary with current form data

