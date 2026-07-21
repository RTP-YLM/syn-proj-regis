# MA Excel Import Feature - Design

**Status**: Draft  
**Date**: May 5, 2026  

## Architecture Overview

### Components

```
┌─────────────────────────────────────────────────────────────┐
│                    Browser UI                              │
│               (Upload Form + Results)                       │
└────────────────────┬────────────────────────────────────────┘
                     │
                     ▼
┌─────────────────────────────────────────────────────────────┐
│              MaController Action                            │
│           POST /Ma/ImportFromExcel                          │
└────────────────┬──────────────────────────────────────────┘
                 │
    ┌────────────┼────────────┐
    │            │            │
    ▼            ▼            ▼
┌──────────┐ ┌──────────┐ ┌──────────┐
│ Excel    │ │Validate  │ │ Enrich   │
│ Parser   │→│ Section  │→│ Data     │
│(EPPlus)  │ │ Data     │ │(Lookups) │
└──────────┘ └──────────┘ └────┬─────┘
                                │
                                ▼
                    ┌───────────────────────┐
                    │  Create MA Records    │
                    │  (Sequential calls)   │
                    └───────────┬───────────┘
                                │
                ┌───────────────┼───────────────┐
                │               │               │
                ▼               ▼               ▼
            ┌────────┐   ┌─────────┐    ┌────────────┐
            │ Create │   │  Items  │    │ Addresses  │
            │   MA   │→  │  + PMs  │→   │  + Items   │
            └────────┘   └─────────┘    └────────────┘
                │               │               │
                └───────────────┼───────────────┘
                                │
                                ▼
                    ┌───────────────────────┐
                    │ Return Response       │
                    │ Success + IDs OR      │
                    │ Errors with Details   │
                    └───────────────────────┘
```

## API Contract

### New Endpoint

```csharp
[HttpPost("ImportFromExcel")]
[Authorize]
public async Task<IActionResult> ImportFromExcel(IFormFile file)
```

**Request**: Multipart form file (Excel .xlsx)  
**Response**: `ImportMaResponse`  
**Status Codes**:
- `200 OK`: Import succeeded (all or partial)
- `201 Created`: Import succeeded (all records created)
- `400 Bad Request`: Validation errors (see response.ValidationErrors)
- `422 Unprocessable Entity`: Data conflicts or lookup failures
- `500 Internal Server Error`: System errors

### Request/Response DTOs

#### ImportMaRequest
```csharp
public class ImportMaRequest : BaseRequest
{
    // Tab 1: Customer Info
    public MaHeaderImport Header { get; set; } = new();
    public string CustomerType { get; set; } // "Dealer" or "User"
    public int? SignType { get; set; } // 1, 2
    public int? SignReceiveType { get; set; } // 0, 1
    
    // Tab 2: Details
    public List<MaItemImport> Items { get; set; } = new();
    public ConditionsImport Conditions { get; set; } = new();
    public List<MaPmRoundImport> PmRounds { get; set; } = new();
    
    // Tab 3: Addresses (MULTIPLE)
    public List<MaInstallAddressImport> InstallAddresses { get; set; } = new();
}
```

#### ImportMaResponse
```csharp
public class ImportMaResponse : BaseResponse
{
    public bool Success { get; set; }
    public long? MaintenanceID { get; set; }
    public long? DealerID { get; set; }
    public long? UserID { get; set; }
    public List<long?> ItemIDs { get; set; } = new();
    public List<long?> AddressIDs { get; set; } = new();
    public List<long?> PmRoundIDs { get; set; } = new();
    public string Message { get; set; }
    public string ErrorDetails { get; set; }
    public List<ValidationError> ValidationErrors { get; set; } = new();
}

public class ValidationError
{
    public string Field { get; set; }
    public string Message { get; set; }
    public string Section { get; set; } // "Header"|"Items"|"Address"|"PM"
    public int? RowNumber { get; set; }
    public int? ColumnNumber { get; set; }
}
```

## Import Processing Flow

### Phase 1: Parse & Validate

```
ReadExcel()
├─ Sheet validation (single sheet required)
├─ Parse Header Section (rows 1-13)
│  ├─ Validate RunningNo (required, unique check)
│  ├─ Validate CustomerType (Dealer/User)
│  ├─ Validate ContactDate format (yyyy-MM-dd)
│  ├─ Validate Dealer info (names, addresses)
│  ├─ Validate User info (names, addresses)
│  └─ Check for duplicates (RunningNo)
│
├─ Parse Items Section (rows 14-N)
│  ├─ Validate ItemCode (required)
│  ├─ Validate Qty > 0
│  ├─ Count SerialText comma-separated values
│  ├─ Verify Qty == SerialText count
│  └─ Validate Price ≥ 0
│
├─ Parse Address Section (rows N+1-M)
│  ├─ Multiple addresses allowed
│  ├─ Validate Name (required)
│  ├─ Validate Address (required)
│  ├─ Validate InstallDate format
│  ├─ Validate ContactTel (optional but formatted if provided)
│  └─ Validate Qty > 0
│
├─ Parse PM Rounds (rows M+1-P)
│  ├─ Validate Round 1-21 exists
│  ├─ Validate each RoundDate format (yyyy-MM-dd)
│  ├─ Verify Rounds ordered by date
│  └─ Validate Package name (required)
│
└─ Collect All Errors → Return ValidationError[] if any
```

**Error Handling**: If any validation errors found, return 400 with all errors. No creation attempted.

### Phase 2: Enrich Data

```
EnrichData(ImportMaRequest)
├─ Lookup Province IDs by name
├─ Lookup District IDs by (Province, name)
├─ Lookup SubDistrict IDs by (District, name)
├─ Lookup Zipcode by Province/District/SubDistrict
├─ Pre-fetch position lookup table
├─ Parse Conditions (Y/N → boolean)
└─ Build complete MaHeaderImport with all IDs

If any lookup fails:
  └─ Add ValidationError with missing reference
  └─ Return 422 Unprocessable Entity
```

### Phase 3: Create Records (Transactional Scope)

```
CreateMaRecords(enrichedRequest)
├─ BEGIN TRANSACTION
│
├─ 1. Get or Create Dealer
│   └─ POST /Api/Dealers/Add or lookup existing
│   └─ Store DealerID
│
├─ 2. Get or Create User
│   └─ POST /Api/Users/Add or lookup existing
│   └─ Store UserID
│
├─ 3. Create Maintenance Header
│   └─ POST /Api/Maintenance/Create
│   └─ Store MaintenanceID
│
├─ 4. Create Install Addresses (loop)
│   └─ For each address in list:
│       ├─ POST /Api/Maintenance/{MaintenanceID}/Addresses
│       └─ Store AddressIDs[]
│
├─ 5. Create Items (loop)
│   └─ For each item in list:
│       ├─ POST /Api/Maintenance/{MaintenanceID}/Items
│       └─ Store ItemIDs[]
│
├─ 6. Create PM Rounds (loop)
│   └─ For each PM round:
│       ├─ POST /Api/Maintenance/{MaintenanceID}/Items/{ItemID}/PM
│       └─ Store PmRoundIDs[]
│
├─ If ANY error:
│   ├─ ROLLBACK TRANSACTION
│   ├─ Log error with context
│   └─ Return 500 error response
│
└─ COMMIT TRANSACTION
  └─ Return 201 Created with all IDs
```

**Important**: Use database transaction to ensure atomicity. If any child creation fails, rollback entire MA.

## File Structure

```
Models/Request/
├─ ImportMaRequest.cs (root import request)
├─ MaHeaderImport.cs
├─ MaItemImport.cs
├─ MaInstallAddressImport.cs
├─ MaPmRoundImport.cs
├─ ConditionsImport.cs
└─ ValidationError.cs

Models/Response/
├─ ImportMaResponse.cs

Helper/
├─ ExcelImportHelper.cs (parsing)
├─ ImportValidator.cs (validation rules)
├─ ImportDataEnricher.cs (lookups & enrichment)
└─ ImportService.cs (orchestration)

Controllers/
└─ MaController.cs (add ImportFromExcel action)

Views/MA/
├─ Import.cshtml (upload form)
└─ ImportResult.cshtml (results/errors)
```

## Validation Rules by Section

### Header Validation
| Field | Rule | Example |
|-------|------|---------|
| RunningNo | Required, alphanumeric, unique | MA-2026-001 |
| ProjectName | Required, max 255 chars | Project X |
| ContactDate | Required, yyyy-MM-dd format | 2026-05-05 |
| CustomerType | Required, "Dealer" or "User" | Dealer |
| SignType | Optional, 1 or 2 | 1 |
| SignReceiveType | Optional, 0 or 1 | 0 |

### Item Validation
| Field | Rule | Example |
|-------|------|---------|
| ItemCode | Required, max 50 chars | ASR-001 |
| ItemName | Required, max 255 chars | Server Unit |
| Qty | Required, > 0 | 2 |
| SerialText | Required, comma-separated | SN001,SN002 |
| Price | Required, ≥ 0, 2 decimals | 5000.00 |

### Address Validation  
| Field | Rule | Example |
|-------|------|---------|
| InstallDate | Required, yyyy-MM-dd format | 2026-05-05 |
| Name | Required, max 255 chars | Headquarters |
| Address | Required, max 500 chars | 123 Main St |
| Province | Required, valid ID lookup | 10 |
| Qty | Required, > 0 | 5 |
| ContactTel | Optional, phone format | +66-2-123-4567 |

### PM Round Validation
| Field | Rule | Example |
|-------|------|---------|
| Round | Required, 1-21 | 1 |
| RoundDate | Required, yyyy-MM-dd format | 2026-06-01 |
| Package | Required, max 100 chars | Basic |
| Price | Optional, ≥ 0 | 500.00 |

## Error Response Example

```json
{
  "success": false,
  "statusCode": 400,
  "message": "Validation errors found. See details.",
  "validationErrors": [
    {
      "field": "RunningNo",
      "message": "Maintenance Agreement with RunningNo 'MA-2026-001' already exists",
      "section": "Header",
      "rowNumber": 1,
      "columnNumber": 1
    },
    {
      "field": "Qty",
      "message": "Quantity (3) does not match serial count (2)",
      "section": "Items",
      "rowNumber": 16,
      "columnNumber": 3
    },
    {
      "field": "InstallDate",
      "message": "Date format must be yyyy-MM-dd",
      "section": "Address",
      "rowNumber": 22,
      "columnNumber": 1
    }
  ],
  "errorDetails": "3 validation errors found. Please correct and resubmit."
}
```

## Performance Considerations

- **Row Limit**: Design for up to 1000 items per import session
- **Timeout**: Set MVC timeout to 5 minutes for large imports
- **Lookup Caching**: Cache Province/District lookups for duration of import
- **Batch Strategy**: Process items sequentially (simpler error tracking)

---

**Design Approved**: ⏳ Pending Review

