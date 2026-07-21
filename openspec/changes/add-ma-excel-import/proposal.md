# MA Excel Import Feature - Proposal

**Status**: In Development  
**Created**: May 5, 2026  
**Last Updated**: May 5, 2026  

## Problem Statement

Currently, creating bulk Maintenance Agreements (MA) in the Syndome CRM system requires:
- Manual navigation through 4 sequential tabs in the Detail.cshtml form
- Repetitive data entry for headers, items, addresses, and PM schedules
- High risk of data entry errors due to form complexity
- Significant time investment for dealers with large equipment portfolios

**Example**: Creating 50 MAs with 5 items each = ~2-3 hours of manual data entry.

## Objectives

1. **Enable bulk MA creation** via Excel template import
2. **Reduce data entry time** from hours to minutes
3. **Minimize validation errors** through template-driven structure
4. **Maintain data integrity** by reusing existing validation rules from Detail.cshtml form

## Scope

### What Gets Imported

| Section | Data | Quantity | Mapping |
|---------|------|----------|---------|
| **Header** | Maintenance record metadata, dealer/user info, conditions | 1 per import | MaDetailRequest |
| **Items** | Equipment details with serial tracking | Multiple (1-N) | MaintenanceItemRequest |
| **Addresses** | Installation locations and contact info | Multiple (1-N) | AddMaInstallAddressRequest |
| **PM Rounds** | Preventive maintenance schedule | 1-21 per item | AddMaItemPmRequest |

### Template Structure

**Excel sheets**: Single sheet with sections:
- Rows 1-13: Maintenance header information
- Rows 14-N: Maintenance items list
- Rows N+1-M: Installation addresses list
- Rows M+1-P: PM schedule (up to 21 rounds)

**Date Format**: `yyyy-MM-dd` (ISO 8601)  
**Date/Time Fields**: InstallDate, ContactDate, RoundDate  
**Serial Format**: Comma-separated list (e.g., "SN001,SN002,SN003")

### Out of Scope

- Multi-sheet templates
- Custom column ordering/mapping
- Asynchronous import (start with synchronous)
- Direct web editing of template
- Import history audit trail (covered by existing logs)

## Success Criteria

| Criterion | Target |
|-----------|--------|
| **Performance** | Import 100 MAs in < 5 minutes |
| **Accuracy** | 100% validation against existing rules |
| **Error Reporting** | All validation errors reported with row/cell reference |
| **Field Coverage** | All Detail.cshtml form fields supported |
| **Rejection Workflow** | Support partial success with error correction options |

## Data Mapping Reference

### Header Section (MaDetailRequest)
```
Excel Column → Model Property
A1: RunningNo → MaDetail.RunningNo
B1: ProjectName → MaDetail.ProjectName
C1: ContactDate → MaDetail.ContactDate (yyyy-MM-dd)
A2: CustomerType → ImportMaRequest.CustomerType
B2: SignType → ImportMaRequest.SignType
C2: SignReceiveType → ImportMaRequest.SignReceiveType
```

### Dealer Section (from MaDetailRequest)
```
A3: DealerName → MaDetail.DealerContactName (via AddMaDealerRequest)
B3: DealerAddress → MaDetail.DealerAddress
C3: DealerProvince → MaDetail.DealerProvince
[... continues through DealerLineId]
```

### Items Section (MaintenanceItemRequest)
```
Row 14+:
ItemCode → MaintenanceItem.ItemCode
ItemName → MaintenanceItem.ItemName
Qty → MaintenanceItem.Qty (must match SerialText count)
SerialText → MaintenanceItem.SerialText (comma-separated)
Price → MaintenanceItem.Price
TotalPrice → MaintenanceItem.TotalPrice
```

### Address Section (AddMaInstallAddressRequest - Multiple)
```
InstallDate → AddMaInstallAddressRequest.InstallDate (yyyy-MM-dd)
Name → AddMaInstallAddressRequest.Name
Branch → AddMaInstallAddressRequest.Branch
Address → AddMaInstallAddressRequest.Address
Province → AddMaInstallAddressRequest.Province (lookup by ID)
[... continues through ContactTel, Qty]
```

### PM Schedule Section (AddMaItemPmRequest.PmRound - up to 21)
```
Round → PmRound.Round (1-21)
PM<n>_Date → PmRound.RoundDate (yyyy-MM-dd)
PM<n>_Pkg → PmRound.Package
PM<n>_Price → PmRound.Price (optional)
```

## Dependencies

### Technical
- **Framework**: ASP.NET Core 8.0 (.NET)
- **Library**: EPPlus (already in project)
- **API**: Existing MaController methods (AddDealer, SaveItems, SaveInstallAddress, SaveItemPms)
- **Database**: SQL Server with existing MA schema

### Functional
- **Validation Rules**: Inherit from Detail.cshtml form validation
- **Lookup Tables**: Province, District, SubDistrict, Zipcode
- **Existing Models**: MaDetailRequest, MaintenanceItemRequest, AddMaInstallAddressRequest, AddMaItemPmRequest

## Implementation Timeline & Effort

| Phase | Tasks | Effort | Duration |
|-------|-------|--------|----------|
| **1. Models** | Create ImportMaRequest hierarchy, validation | 3 pts | 1 day |
| **2. Excel Parser** | Parse template, type conversion, data enrichment | 5 pts | 2 days |
| **3. Validation** | Implement validation layer reusing form rules | 5 pts | 2 days |
| **4. API Integration** | New endpoint, orchestrate existing endpoints | 5 pts | 2 days |
| **5. UI** | Upload form, progress/error reporting | 3 pts | 1 day |
| **6. Error Handling** | Structured error response, partial success logic | 3 pts | 1 day |
| **7. Testing** | Unit tests, integration tests, template tests | 5 pts | 2 days |
| **Total** | | **29 pts** | **11 days** |

## High-Level Architecture

```
Excel File Upload
    ↓
Parse Template (EPPlus) → ImportMaRequest
    ↓
Validate All Sections → ValidationError[]
    ↓
Enrich Data (Lookups) → Enriched ImportMaRequest
    ↓
Create MA Records (Sequential API calls)
    ├→ CreateMaintenance() → MaintenanceID
    ├→ AddDealer() 
    ├→ AddUser()
    ├→ SaveItems() → ItemIDs[]
    ├→ SaveInstallAddresses() → AddressIDs[]
    ├→ SaveItemPms() → PmRoundIDs[]
    ↓
Return ImportMaResponse (Success + Created IDs OR Errors)
    ↓
Display Results (UI feedback)
```

## Risk & Mitigation

| Risk | Impact | Mitigation |
|------|--------|-----------|
| **Template Structure Confusion** | High effort to correct imports | Provide sample template + guide |
| **Large Bulk Imports Timeout** | API calls exceed timeout | Implement async processing in phase 2 |
| **Data Validation Edge Cases** | Partial import failures | Comprehensive error reporting + rollback logic |
| **Province/District Lookups Fail** | Data enrichment blocks import | Pre-fetch lookup tables, cache for session |

## Next Steps

1. ✅ Approve proposal
2. → Create design document with API contract details
3. → Create specs with validation rules and error codes
4. → Create task checklist for implementation
5. → Develop and test
6. → Deploy and monitor

---

**Approval Status**: ⏳ Pending Review

