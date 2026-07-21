# Customer Name Duplicate Check Specification

## 1. Introduction

This document specifies the requirements for the customer name duplicate check feature. The goal is to prevent the creation of customer records with identical names, ensuring data integrity and a better user experience.

## 2. Functional Requirements

### 2.1. Duplicate Check Trigger

*   **FR-001:** The system shall allow users to initiate a duplicate name check by clicking a "Check" button located next to the customer company name input field on the customer detail page.
*   **FR-002:** The duplicate check should also be implicitly performed when the user attempts to save the customer record, if the name has not been validated recently or if it has changed.

### 2.2. Duplicate Check Mechanism

*   **FR-003:** When triggered, the system shall send the entered customer company name to a backend API endpoint for validation.
*   **FR-004:** The backend API shall query the customer database to determine if a customer with the exact same name (case-insensitive, potentially excluding the current record if editing) already exists.
*   **FR-005:** The backend API shall return a clear boolean indication (`isDuplicate`) and an optional message.

### 2.3. User Feedback

*   **FR-006:** Upon successful validation (name is unique), a green checkmark icon (`fas fa-check-circle`) shall be displayed next to the input field.
*   **FR-007:** Upon detecting a duplicate name, a red 'X' icon (`fas fa-times-circle`) shall be displayed, and a user-friendly message (e.g., "Name already exists") should be shown.
*   **FR-008:** If an error occurs during the check (e.g., API error), a warning icon (`fas fa-exclamation-circle`) shall be displayed.
*   **FR-009:** The system shall display an informative message to the user when a duplicate name is detected, guiding them to choose a different name.

### 2.4. Save Operation Constraint

*   **FR-010:** The customer save operation shall be blocked if the customer name is found to be a duplicate or if the validation check resulted in an error and `isCustomerNameValid` is false. A warning message should be presented to the user.
*   **FR-011:** The system shall allow saving only if the customer name is validated as unique.

### 2.5. Edge Cases

*   **FR-012:** Empty or whitespace-only customer names shall be considered invalid and trigger the error state.
*   **FR-013:** The duplicate check should be case-insensitive.
*   **FR-014:** When editing an existing customer, the check should ideally exclude the current customer's record from the duplicate check to avoid false positives.

## 3. Non-Functional Requirements

### 3.1. Performance

*   **NFR-001:** The duplicate check API response time should be under 500ms to ensure a smooth user experience.

### 3.2. Security

*   **NFR-002:** All communication between frontend and backend must be secured and authenticated.

## 4. Open Issues

*   **OI-001:** Clarify the exact behavior of the backend API regarding case-insensitivity and excluding the current record during edits.
*   **OI-002:** Determine if additional user feedback mechanisms (e.g., inline error messages beyond icons) are required.
