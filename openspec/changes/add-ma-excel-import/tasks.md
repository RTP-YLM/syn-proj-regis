# MA Excel Import Feature - Implementation Tasks

**Status**: Ready for Implementation  
**Total Tasks**: 14  
**Estimated Effort**: 29 story points (~11 working days)

---

## Phase 1: Data Models (3 tasks, 3 pts)

- [ ] **Task 1.1**: Create `ImportMaRequest` hierarchy in Models/Request/
  - `ImportMaRequest.cs` (root class)
  - `MaHeaderImport.cs` (header section)
  - `ConditionsImport.cs` (conditions checkbox)
  - `MaItemImport.cs` (items section)
  - `MaInstallAddressImport.cs` (addresses section)
  - `MaPmRoundImport.cs` (PM rounds section)
  - `ValidationError.cs` (error reporting)
  - **Files to create**: 7 files in Models/Request/
  - **Dependencies**: None
  - **Effort**: 1 pt

- [ ] **Task 1.2**: Create `ImportMaResponse` in Models/Response/
  - Response DTO with success flag, created IDs, validation errors
  - Support both success and error scenarios
  - Include detailed error tracking (row, column, error code)
  - **Files to create**: 1 file in Models/Response/
  - **Dependencies**: Task 1.1
  - **Effort**: 1 pt

- [ ] **Task 1.3**: Add data annotations and validation attributes
  - Add [Required], [StringLength], [Range] to all DTOs
  - Add custom attributes where needed (phone validation, date format)
  - Ensure consistency with existing model patterns
  - **Files to modify**: All files from Tasks 1.1 & 1.2
  - **Dependencies**: Tasks 1.1, 1.2
  - **Effort**: 1 pt

---

## Phase 2: Excel Parsing Helper (2 tasks, 3 pts)

- [ ] **Task 2.1**: Create `ExcelImportHelper.cs` for low-level parsing
  - Method: `ParseExcelFile(IFormFile file) → ImportMaRequest` or error
  - Read from magic row numbers (Header: 1-13, Items: 15-N, Addresses: N+1-M, PM: P)
  - Type conversion: String → int/decimal/date based on expected type
  - Handle date format conversion: Excel date serial → yyyy-MM-dd string
  - Parse comma-separated serials properly
  - Handle blank cells and optional fields
  - **File to create**: Helper/ExcelImportHelper.cs
  - **Dependencies**: Task 1.1, EPPlus library
  - **Effort**: 2 pts

- [ ] **Task 2.2**: Create `ExcelImportHelper.cs` validation methods
  - Method: `ValidateFileFormat(IFormFile file) → bool, error message`
  - Check file type (.xlsx only)
  - Check file size (< 10 MB)
  - Check sheet count (single sheet required)
  - Check row count (≤ 1000 items)
  - **File to modify**: Helper/ExcelImportHelper.cs (extend from Task 2.1)
  - **Dependencies**: Task 2.1
  - **Effort**: 1 pt

---

## Phase 3: Validation Layer (2 tasks, 4 pts)

- [ ] **Task 3.1**: Create `ImportValidator.cs` for all validation rules
  - Method: `ValidateHeader(MaHeaderImport, out List<ValidationError>) → bool`
    - Check all required fields (ref: spec section 2)
    - Validate formats (RunningNo, phone, emails)
    - Validate ranges (SignType: 1-2, SignReceiveType: 0-1)
    - Check RunningNo uniqueness against DB
  - Method: `ValidateItems(List<MaItemImport>, out List<ValidationError>) → bool`
    - Check required fields per row
    - Verify Qty > 0
    - Verify SerialText count == Qty
    - Verify Price ≥ 0
  - Method: `ValidateAddresses(List<MaInstallAddressImport>, out List<ValidationError>) → bool`
    - Check required fields
    - Validate dates (yyyy-MM-dd format, valid dates)
    - Check Qty > 0 per address
    - Validate phone format if provided
  - Method: `ValidatePmRounds(List<MaPmRoundImport>, out List<ValidationError>) → bool`
    - Check rounds 1-21 exist
    - Verify sequential ordering
    - Check dates in ascending order
    - Validate Package field
  - **File to create**: Helper/ImportValidator.cs
  - **Dependencies**: Task 1.1, data models
  - **Effort**: 2 pts

- [ ] **Task 3.2**: Create cross-field validation
  - Method: `ValidateCrossFields(ImportMaRequest, out List<ValidationError>) → bool`
    - Item count > 0
    - Address count > 0
    - PM roundcount ≥ 1 and ≤ 21
    - All sections present
  - **File to modify**: Helper/ImportValidator.cs (extend)
  - **Dependencies**: Task 3.1
  - **Effort**: 1 pt

---

## Phase 4: Data Enrichment (1 task, 2 pts)

- [ ] **Task 4.1**: Create `ImportDataEnricher.cs` for lookups and enrichment
  - Method: `EnrichData(ImportMaRequest, out List<ValidationError>) → EnrichedRequest` (or null)
    - Inject: IHttpContextAccessor (for session cache)
    - Look up Province ID by name → cache in session
    - Look up District ID by (Province, name) → cache
    - Look up SubDistrict ID by (District, name) → cache (optional)
    - Look up Zipcode by (Province, District, SubDistrict) → auto-populate if found
    - Parse Conditions boolean values (Y/N, TRUE/FALSE, 1/0 → bool)
    - Log any lookup failures as ValidationErrors with error codes (ADDR_006, ADDR_008, etc.)
  - Caching strategy: Session-level cache to avoid repeat DB calls
  - Error handling: Collect all lookup failures, don't fail fast
  - **File to create**: Helper/ImportDataEnricher.cs
  - **Dependencies**: Task 1.1, data models, DB context access
  - **Effort**: 2 pts

---

## Phase 5: API Service Orchestration (2 tasks, 5 pts)

- [ ] **Task 5.1**: Create `ImportService.cs` to orchestrate MA creation
  - Method: `CreateMaFromImport(ImportMaRequest, currentUsername) → ImportMaResponse`
    - Open database transaction (using DbContext)
    - Step 1: Create/Get Dealer → store DealerID
    - Step 2: Create/Get User → store UserID
    - Step 3: Create Maintenance header → store MaintenanceID
    - Step 4: Create Install Addresses (loop, accumulate AddressIDs[])
    - Step 5: Create Maintenance Items (loop, accumulate ItemIDs[])
    - Step 6: Create PM Rounds for items (nested loop, accumulate PmRoundIDs[])
    - Error handling: If any step fails, catch exception, log, rollback transaction, return error response
    - Success: Commit transaction, return complete response with all IDs
  - Call existing endpoints via MaController methods (not HTTP, direct method calls)
  - Track which step failed for detailed error messages
  - **File to create**: Services/ImportService.cs
  - **Dependencies**: Tasks 1.1, 1.2, existing MaController
  - **Effort**: 3 pts

- [ ] **Task 5.2**: Add transaction handling and error recovery
  - Implement SaveChanges() within transaction scope
  - Catch specific DB exceptions: duplicate key, constraint violations, etc.
  - Build verbose error messages with context
  - Ensure partial rollback on any failure
  - Test transaction rollback scenarios
  - **File to modify**: Services/ImportService.cs (extend)
  - **Dependencies**: Task 5.1
  - **Effort**: 2 pts

---

## Phase 6: Controller Action (1 task, 2 pts)

- [ ] **Task 6.1**: Add `ImportFromExcel` action to `MaController.cs`
  - Route: `POST /Ma/ImportFromExcel` or `POST /api/Ma/ImportFromExcel`
  - Attribute: `[Authorize]` required
  - Parameter: `IFormFile file`
  - Steps:
    1. Validate file format (via ExcelImportHelper.ValidateFileFormat)
    2. Parse Excel → ImportMaRequest (via ExcelImportHelper.ParseExcelFile)
    3. Run validation (via ImportValidator)
    4. Return 400 if validation errors found
    5. Enrich data with lookups (via ImportDataEnricher)
    6. Return 422 if enrichment fails
    7. Create MA records (via ImportService)
    8. Return 201/200 with response
  - Response codes: 201 (success), 400 (validation), 422 (enrichment), 500 (system error)
  - Log action for audit trail
  - **File to modify**: Controllers/MaController.cs
  - **Dependencies**: Tasks 2.1, 3.1, 4.1, 5.1
  - **Effort**: 2 pts

---

## Phase 7: UI Layer (2 tasks, 4 pts)

- [ ] **Task 7.1**: Create `Import.cshtml` upload form view
  - Bootstrap v5 form styling (match existing forms)
  - File input field with drag-and-drop support (optional enhancement)
  - Submit button with loading spinner
  - Download template button (links to existing Import_MA_Template.xlsx)
  - Instructions/help text for template format
  - Hidden validation messages (shown on error)
  - **File to create**: Views/MA/Import.cshtml
  - **Dependencies**: None (can work in parallel)
  - **Effort**: 1 pt

- [ ] **Task 7.2**: Create error display and results view
  - Create `ImportResult.cshtml` to display:
    - Success message with created MA ID
    - Summary: "Created 50 MAs with 150 items in 45 seconds"
    - Error table (if any) showing field, row, error message
    - Allow re-download corrected template
    - Cancel and return to MA List button
  - Pagination for large error lists (> 50 errors)
  - **File to create**: Views/MA/ImportResult.cshtml
  - **Dependencies**: Task 7.1, ImportMaResponse model
  - **Effort**: 1 pt

---

## Phase 8: Sample Template & Documentation (1 task, 1 pt)

- [ ] **Task 8.1**: Create and document sample import template
  - Already exists: `Template/Import_MA_Template.xlsx`
  - Create template if missing (using EPPlus, or create manually)
  - Add example data with realistic values:
    - 2-3 sample MAs
    - 3-5 items per MA
    - 2 installation addresses
    - 5 PM rounds (not all 21) for demo
  - Document column headers and allowed values in first comment/note on sheet
  - Save as: `Template/Import_MA_Template.xlsx` (already in path)
  - Create: `Template/Import_MA_Template_Guide.md` with usage instructions
  - **Files to create**: Template/Import_MA_Template_Guide.md
  - **Dependencies**: None
  - **Effort**: 1 pt

---

## Phase 9: Integration Testing (2 tasks, 4 pts)

- [ ] **Task 9.1**: Write unit tests for helpers
  - Test ExcelImportHelper: parse various date formats, handle nulls
  - Test ImportValidator: all error scenarios, boundary conditions
  - Test ImportDataEnricher: lookup success/failure, caching
  - Achieve: 90%+ code coverage on helpers
  - Mocks: DB context, IHttpContextAccessor, EPPlus sheet
  - **File to create**: Tests/ImportMaTests/HelperTests.cs
  - **Dependencies**: Tasks 2.1, 3.1, 4.1
  - **Effort**: 2 pts

- [ ] **Task 9.2**: Write integration tests end-to-end
  - Create sample Excel file in memory (via EPPlus)
  - Test full import flow: parse → validate → enrich → create
  - Test success scenario: verify all IDs returned
  - Test error scenarios: validation, lookup failures, conflict MA
  - Test transaction rollback on creation failure
  - Use real DB context (InMemory or test database)
  - **File to create**: Tests/ImportMaTests/IntegrationTests.cs
  - **Dependencies**: All phases 1-6
  - **Effort**: 2 pts

---

## Summary

| Phase | Tasks | Points | Days |
|-------|-------|--------|------|
| 1. Models | 3 | 3 | 1 |
| 2. Parsing | 2 | 3 | 1.5 |
| 3. Validation | 2 | 4 | 2 |
| 4. Enrichment | 1 | 2 | 1 |
| 5. Service | 2 | 5 | 2 |
| 6. Controller | 1 | 2 | 1 |
| 7. UI | 2 | 4 | 1.5 |
| 8. Template | 1 | 1 | 0.5 |
| 9. Testing | 2 | 4 | 2 |
| **TOTAL** | **14** | **29** | **12** |

---

**Ready to Start**: ✓ All tasks defined and sequenced

