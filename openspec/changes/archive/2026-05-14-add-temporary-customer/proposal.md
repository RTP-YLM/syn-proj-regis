# Add Temporary Customer Feature

## Problem Statement

In the expense module, users currently can only select from existing customers via a search modal. When a customer doesn't exist, users must go through the full customer creation workflow which requires extensive information and approval process. This creates friction for expense entry when dealing with one-off or new customers.

## Solution Overview

Add a "เพิ่มลูกค้าชั่วคราว" (Add Temporary Customer) button next to the customer search button in the expense detail page. This opens a simplified modal for creating temporary customers with minimal required fields, bypassing the full approval workflow.

## Key Requirements

- **Simplified Form**: Only require company name, optional contact info and address
- **Auto-Selection**: After creation, automatically select the temporary customer for the current expense
- **Visual Distinction**: Temporary customers appear differently in search results and UI
- **Reusable**: Temporary customers can be selected for multiple expenses
- **API Integration**: New backend endpoint to create temporary customers

## Success Criteria

- Users can quickly create customers without leaving the expense page
- Temporary customers are clearly distinguished from permanent customers
- No disruption to existing customer search/selection workflow
- Temporary customers integrate seamlessly with expense functionality

## Scope

**In Scope:**
- Add temporary customer button and modal to expense detail page
- Create simplified customer creation form
- Backend API for temporary customer creation
- Visual styling to distinguish temporary customers
- Integration with existing customer search functionality

**Out of Scope:**
- Converting temporary customers to permanent customers
- Temporary customer management/administration
- Integration with other modules beyond expense

## Assumptions

- Temporary customers use the same database table with an `IsTemporary` flag
- Temporary customers follow same contact and document attachment patterns
- No special cleanup process needed for temporary customers
