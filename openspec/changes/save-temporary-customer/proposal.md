## Why

Users need the ability to save customer information temporarily without completing the full customer creation workflow. This allows users to preserve partially entered customer data for later completion, improving user experience by preventing data loss during the customer entry process.

## What Changes

- Add a "Save as Temporary Customer" button to the customer form
- Wire the button to call the `CreateTemporary` action on the CustomerController
- Store the customer data with a temporary status that distinguishes it from fully created customers
- Display temporary customer records in a filterable view so users can resume or delete them later

## Capabilities

### New Capabilities
- `save-temporary-customer`: Ability to save customer information as a temporary record that can be resumed or deleted later
- `temporary-customer-list`: Ability to view and manage temporary customer records

### Modified Capabilities

## Impact

- **UI Changes**: Customer form in the Expense and Quotation workflows will have a new save button
- **Controller Changes**: CustomerController will need a new `CreateTemporary` action
- **Database Changes**: Customer records may need a status field to distinguish temporary from permanent records
- **API Changes**: New endpoint for saving temporary customers

