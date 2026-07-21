# Temporary Customer Feature - Implementation Tasks

## Backend API Tasks

### 1. Database Schema Changes
- [ ] Add `IsTemporary` BIT column to Customer table (default 0)
- [ ] Add `CreatedForExpenseId` BIGINT column to Customer table (nullable)
- [ ] Create database migration script

### 2. API Models & Endpoints
- [ ] Create `TempCustomerRequest.cs` in Models/Request/
- [ ] Create `TempCustomerResponse.cs` in Models/Response/
- [ ] Add new endpoint `POST /api/customer/v1/create-temporary` in CustomerController
- [ ] Implement code generation logic for temporary customer codes
- [ ] Add validation for required fields (company name)
- [ ] Add duplicate name checking for temporary customers

### 3. Business Logic
- [ ] Implement temporary customer creation service method
- [ ] Add logic to set IsTemporary = true and link to expense
- [ ] Ensure temporary customers bypass approval workflow
- [ ] Update customer search to include temporary customers

## Frontend UI Tasks

### 4. View Modifications
- [ ] Add "เพิ่มลูกค้าชั่วคราว" button to `_Customer.cshtml` partial
- [ ] Create new modal `modal-add-temp-customer` with simplified form
- [ ] Add form validation for required fields
- [ ] Style modal to match existing design patterns

### 5. JavaScript Implementation
- [ ] Add click handler for `#btn-add-temp-customer` button
- [ ] Add click handler for `#btn-save-temp-customer` button
- [ ] Implement `saveTempCustomer()` function to call new API
- [ ] Add auto-selection logic after successful creation
- [ ] Update customer display fields with new customer data
- [ ] Add form reset and modal close logic

### 6. Search Integration
- [ ] Modify customer search results to show temporary customers
- [ ] Add visual distinction (badge/label) for temporary customers
- [ ] Ensure temporary customers can be selected like regular customers

## Styling & UX Tasks

### 7. CSS Styling
- [ ] Add styles for temporary customer visual distinction
- [ ] Style the new button to match existing UI patterns
- [ ] Add responsive design for the modal on different screen sizes

### 8. User Experience
- [ ] Add loading indicators during API calls
- [ ] Implement proper error handling and user feedback
- [ ] Add success confirmation after customer creation
- [ ] Ensure modal closes and form resets after successful creation

## Testing Tasks

### 9. Unit Tests
- [ ] Test API endpoint with valid/invalid data
- [ ] Test code generation logic
- [ ] Test model validation
- [ ] Test database operations

### 10. Integration Tests
- [ ] Test end-to-end customer creation flow
- [ ] Test expense save with temporary customer
- [ ] Test customer search includes temporary customers
- [ ] Test contact addition to temporary customers

### 11. UI Tests
- [ ] Test modal opens/closes correctly
- [ ] Test form validation
- [ ] Test auto-selection after creation
- [ ] Test visual distinction in search results

## Documentation Tasks

### 12. Code Documentation
- [ ] Add XML comments to new API methods
- [ ] Document new request/response models
- [ ] Add JavaScript function comments

### 13. User Documentation
- [ ] Update user guide for temporary customer feature
- [ ] Add screenshots of new modal and workflow
- [ ] Document limitations and differences from permanent customers

## Deployment Tasks

### 14. Configuration
- [ ] Add new API endpoint to appsettings.json (if needed)
- [ ] Update any relevant configuration files

### 15. Migration
- [ ] Create database migration for new columns
- [ ] Test migration on staging environment
- [ ] Plan rollback strategy if needed

## Quality Assurance

### 16. Code Review
- [ ] Review backend code for security and performance
- [ ] Review frontend code for consistency and best practices
- [ ] Ensure proper error handling throughout

### 17. Final Testing
- [ ] Perform end-to-end testing in staging environment
- [ ] Test with different user roles and permissions
- [ ] Validate performance impact on existing functionality
