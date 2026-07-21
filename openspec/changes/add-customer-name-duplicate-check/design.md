# Design for Add Customer Name Duplicate Check

## Overview

This document outlines the design for the feature that checks for duplicate customer names before allowing a new customer to be saved or an existing one to be updated. This aims to prevent data inconsistencies and improve user experience by providing immediate feedback.

## Architecture

The implementation involves changes across the frontend (Razor View, JavaScript), backend (Controller), and API configuration (`appsettings.json`).

### Frontend
- **Customer Detail View (`Views/Customer/Detail.cshtml`):**
    - Adds a "Check" button next to the company name input field (`#customer-company`).
    - Adds a `span` element (`#company-name-validation-status`) to display validation icons (success/error).
- **Customer Detail JavaScript (`wwwroot/js/page/customer/detail.js`):**
    - A new function `checkCompanyNameDuplicate()` will be implemented.
    - This function will be triggered by the "Check" button click or on input blur.
    - It will make an AJAX POST request to the backend controller.
    - It will update the `#company-name-validation-status` span with Font Awesome icons (`fa-check-circle` for valid, `fa-times-circle` for duplicate/error).
    - It will manage a flag (`isCustomerNameValid`) to indicate the validation status.
    - The save logic will be modified to prevent saving if `isCustomerNameValid` is false.
    - An initial check will be performed on page load for existing customer names.

### Backend
- **Customer Controller (`Controllers/CustomerController.cs`):**
    - A new `HttpPost` action method `CheckDuplicateCustomerName` will be added.
    - This method will accept a `CheckDuplicateNameRequest` object (containing `CustomerName` and `CustomerId`).
    - It will construct the API URL based on `appsettings.json` and call the backend customer API.
    - It will return a `CheckDuplicateNameResponse` object indicating `IsDuplicate` and an optional `Message`.

### API Configuration (`appsettings.json`)
- The existing `ApiUrl.Customer.CheckDuplicateName` setting will be used. It is expected to be a URL template like `"/api/customer/v1/check-name-duplicate?customerName={0}"`.

## Data Flow

1.  User types into the `#customer-company` input.
2.  User clicks the "Check" button.
3.  JavaScript (`checkCompanyNameDuplicate`) gets the company name and current customer ID.
4.  JavaScript makes a POST request to `CustomerController.CheckDuplicateCustomerName`.
5.  The Controller constructs the full API URL and calls the backend customer service.
6.  The customer service checks the database for the provided `customerName` (potentially excluding the current `CustomerId`).
7.  The customer service returns a boolean `IsDuplicate` status.
8.  The Controller returns this status to the frontend.
9.  JavaScript updates the `#company-name-validation-status` icon and `isCustomerNameValid` flag.
10. If the name is valid and user attempts to save, the `AutoSaveCustomer` function proceeds. If invalid, saving is blocked.

## User Experience

-   **Immediate Feedback:** Users get instant visual feedback on name duplication.
-   **Clear Indicators:** Checkmark for valid, X mark for invalid.
-   **Preventative:** Prevents saving with duplicate names, reducing data integrity issues.
-   **Error Handling:** Gracefully handles API errors.

## Technical Considerations

-   **API Endpoint:** Ensure the backend API endpoint is correctly configured and handles the check efficiently.
-   **URL Encoding:** Ensure customer names are URL-encoded when passed in the URL.
-   **Authentication:** The API call requires authentication tokens, which are handled by `HttpRequestHelper`.
-   **Error Handling:** Robust error handling on both frontend and backend is crucial.
