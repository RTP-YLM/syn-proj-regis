# Tasks for Add Customer Name Duplicate Check

- [x] Define `CheckDuplicateNameRequest` and `CheckDuplicateNameResponse` models in the backend.
- [x] Add `CheckDuplicateCustomerName` POST action method to `CustomerController.cs`.
- [x] Implement API URL construction and call to backend service from the controller action.
- [x] Modify `Views/Customer/Detail.cshtml` to add the "Check" button and validation status indicator.
- [x] Add `isCustomerNameValid` flag in `wwwroot/js/page/customer/detail.js`.
- [x] Implement `checkCompanyNameDuplicate()` JavaScript function for API call and status updates.
- [x] Add event listener for `#check-company-name-btn` to trigger `checkCompanyNameDuplicate()`.
- [x] Integrate validation check into the save logic (inside `.btn-status` click handler) to prevent saving if `isCustomerNameValid` is false.
- [x] Add initial duplicate name check on page load for existing customers in `wwwroot/js/page/customer/detail.js`.
- [x] Ensure proper error handling and user feedback for all stages (API errors, duplicates, empty fields).
