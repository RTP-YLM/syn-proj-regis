## 1. Database and Model Setup

- [ ] 1.1 Add Status enum to Customer model (Temporary, Active, Archived)
- [ ] 1.2 Add Status property to Customer entity
- [ ] 1.3 Create database migration to add Status column to Customers table
- [ ] 1.4 Set default value for Status to "Active" for existing records
- [ ] 1.5 Apply migration to development database

## 2. Backend API Implementation

- [ ] 2.1 Add CreateTemporary action method to CustomerController
- [ ] 2.2 Implement CreateTemporary to accept customer form data
- [ ] 2.3 Implement validation logic that allows partial data for temporary saves
- [ ] 2.4 Set Customer status to "Temporary" when saving via CreateTemporary
- [ ] 2.5 Return customer ID and success response from CreateTemporary
- [ ] 2.6 Add GetTemporaryCustomers action to retrieve temporary customer list
- [ ] 2.7 Add DeleteTemporaryCustomer action for deletion
- [ ] 2.8 Add UpdateTemporaryCustomer action for resuming edits
- [ ] 2.9 Add ConvertToPermament action to convert temporary to active customer

## 3. Frontend UI Implementation

- [ ] 3.1 Add "Save as Temporary Customer" button to customer form modal
- [ ] 3.2 Style the button as secondary/alternative action button
- [ ] 3.3 Wire button click event to call POST /Customer/CreateTemporary
- [ ] 3.4 Implement success notification on temporary save
- [ ] 3.5 Add error handling and display validation errors
- [ ] 3.6 Add option to continue editing or view temporary list after save
- [ ] 3.7 Create Temporary Customers list view
- [ ] 3.8 Implement list table with columns: Name, Contact, Phone, Created Date
- [ ] 3.9 Add action buttons: Edit, Convert to Permanent, Delete
- [ ] 3.10 Implement filter/search functionality for temporary customers
- [ ] 3.11 Add empty state message when no temporary customers exist
- [ ] 3.12 Implement delete confirmation dialog
- [ ] 3.13 Implement edit mode that loads customer data into form

## 4. Integration and Workflows

- [ ] 4.1 Integrate temporary save with Expense workflow
- [ ] 4.2 Integrate temporary save with Quotation workflow
- [ ] 4.3 Update customer dropdown to filter out temporary customers by default (optional show)
- [ ] 4.4 Add link/navigation to temporary customer list from main menu or customer page
- [ ] 4.5 Implement status display for temporary customers (badge/indicator)

## 5. Testing and Validation

- [ ] 5.1 Create unit tests for CreateTemporary action
- [ ] 5.2 Create unit tests for temporary customer queries
- [ ] 5.3 Create unit tests for status conversion
- [ ] 5.4 Test button functionality in customer form
- [ ] 5.5 Test successful temporary save and response handling
- [ ] 5.6 Test validation errors on incomplete data
- [ ] 5.7 Test temporary customer list display and filtering
- [ ] 5.8 Test edit flow - load temporary customer into form
- [ ] 5.9 Test convert to permanent flow
- [ ] 5.10 Test delete temporary customer
- [ ] 5.11 Verify temporary customers don't appear in normal customer lists
- [ ] 5.12 Manual end-to-end testing in Expense workflow
- [ ] 5.13 Manual end-to-end testing in Quotation workflow

## 6. Documentation and Cleanup

- [ ] 6.1 Document the CreateTemporary API endpoint
- [ ] 6.2 Update Customer entity documentation
- [ ] 6.3 Add comments to CreateTemporary and related methods
- [ ] 6.4 Create user-facing help text or tooltip for "Save as Temporary" button
- [ ] 6.5 Code review and merge to main branch

