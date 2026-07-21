# MA Excel Import Feature - Specifications

**Status**: Draft  
**Date**: May 5, 2026  

## 1. Excel Template Specification

### File Requirements
- **Format**: `.xlsx` (Office Open XML)
- **Sheet Count**: Single active sheet (others ignored)
- **Row Limit**: Max 1000 rows (hard limit for performance)
- **File Size**: Max 10 MB
- **Character Encoding**: UTF-8

### Template Sections & Column Layout

#### Section A: Maintenance Header (Rows 1-13)

| Row | Column A | Column B | Column C |
|-----|----------|----------|----------|
| 1 | RunningNo | ProjectName | ContactDate |
| 2 | CustomerType | SignType | SignReceiveType |
| 3 | DealerName | DealerAddress | DealerProvince |
| 4 | DealerDistrict | DealerSubDistrict | DealerZipcode |
| 5 | DealerContactName | DealerContactTel | DealerContactEmail |
| 6 | DealerContactPosition | DealerContactLineId | |
| 8 | UserName | UserAddress | UserProvince |
| 9 | UserDistrict | UserSubDistrict | UserZipcode |
| 10 | UserContactName | UserContactTel | UserContactEmail |
| 11 | UserContactPosition | UserContactLineId | |
| 13 | Condition24Hr | ConditionGoldCoverage | ConditionSilverCoverage |
| 13 | ConditionOnSite24Hr | ConditionOnSite48Hr | |

**Data Types**:
- RunningNo: STRING (max 50)
- CustomerType: STRING ("Dealer" or "User")
- SignType: INTEGER (1 or 2)
- SignReceiveType: INTEGER (0 or 1)
- ContactDate: DATE (yyyy-MM-dd)
- Province/District/SubDistrict: INTEGER (lookup IDs)
- Condition*: BOOLEAN (Y/N, TRUE/FALSE, 1/0, or empty)

#### Section B: Maintenance Items (Rows 15-N)

| Column | Name | Type | Required | Notes |
|--------|------|------|----------|-------|
| A | ItemCode | STRING | Yes | Max 50 chars, e.g. "ASR-001" |
| B | ItemName | STRING | Yes | Max 255 chars |
| C | Qty | INTEGER | Yes | > 0, must match SerialText count |
| D | SerialText | STRING | Yes | Comma-separated, e.g. "SN001,SN002,SN003" |
| E | Price | DECIMAL(10,2) | Yes | ≥ 0 |
| F | TotalPrice | DECIMAL(10,2) | No | Auto-calculated if empty: Qty × Price |

**Example Row**:
```
ItemCode | ItemName      | Qty | SerialText     | Price  | TotalPrice
ASR-001  | Server Unit   | 2   | SN001,SN002    | 5000   | 10000
ASR-002  | Network Card  | 1   | SN003          | 3000   | 3000
```

#### Section C: Installation Addresses (Rows N+1-M)

| Column | Name | Type | Required | Notes |
|--------|------|------|----------|-------|
| A | InstallDate | DATE | Yes | yyyy-MM-dd format |
| B | Name | STRING | Yes | Site/Branch name, max 255 |
| C | Branch | STRING | No | Branch code, max 50 |
| D | Address | STRING | Yes | Full address, max 500 |
| E | Province | INTEGER | Yes | Province ID lookup |
| F | District | INTEGER | Yes | District ID lookup |
| G | SubDistrict | INTEGER | No | SubDistrict ID |
| H | Zipcode | STRING | No | Auto-filled if found |
| I | ContactName | STRING | Yes | Contact person name |
| J | ContactTel | STRING | Yes | Phone/Mobile, with format |
| K | Qty | INTEGER | Yes | > 0, units at this location |

**Multiple Addresses Allowed**: Each row is a separate address for the same MA.

**Example Rows**:
```
InstallDate | Name        | Branch | Address    | Province | Qty
2026-05-05  | Headquarters| BKK01  | 123 Main St| 10       | 5
2026-05-05  | Branch 1    | BKK02  | 456 Sec 2 | 10       | 3
```

#### Section D: PM Schedule (Row P - Single Row)

Columns: `Round | PM1_Date | PM1_Pkg | PM2_Date | PM2_Pkg | ... | PM21_Date | PM21_Pkg`

| Column Pattern | Type | Format | Required | Notes |
|----------------|------|--------|----------|-------|
| PMn_Date | DATE | yyyy-MM-dd | Yes | Maintenance date for round n |
| PMn_Pkg | STRING | Max 100 | Yes | Package type (Basic, Standard, Premium) |
| PMn_Price | DECIMAL | (10,2) | No | Cost for this round |

**Example Row** (compact view):
```
Round | PM1_Date   | PM1_Pkg | PM2_Date   | PM2_Pkg | ... | PM21_Date  | PM21_Pkg
1-21  | 2026-06-01 | Basic   | 2026-07-01 | Basic   | ... | 2027-02-01 | Basic
```

---

## 2. Validation Specification

### Validation Rules by Field

#### Header Fields

| Field | Rule | Error Code | Message |
|-------|------|-----------|---------|
| RunningNo | Required | HDR_001 | RunningNo is required |
| RunningNo | Max 50 chars | HDR_002 | RunningNo exceeds 50 characters |
| RunningNo | Unique check | HDR_003 | MA with RunningNo '{value}' already exists |
| ProjectName | Required | HDR_004 | ProjectName is required |
| CustomerType | Required | HDR_005 | CustomerType is required |
| CustomerType | Value in (Dealer, User) | HDR_006 | CustomerType must be 'Dealer' or 'User' |
| SignType | Value in (1, 2) if provided | HDR_007 | SignType must be 1 or 2 |
| SignReceiveType | Value in (0, 1) if provided | HDR_008 | SignReceiveType must be 0 or 1 |
| ContactDate | Required | HDR_009 | ContactDate is required |
| ContactDate | Format yyyy-MM-dd | HDR_010 | ContactDate must be in yyyy-MM-dd format |
| ContactDate | Valid date | HDR_011 | ContactDate is not a valid date |
| DealerName | Required | HDR_012 | DealerName is required |
| DealerAddress | Required | HDR_013 | DealerAddress is required |
| DealerProvince | Valid province ID | HDR_014 | DealerProvince '{value}' not found in system |
| UserName | Required | HDR_015 | UserName is required |
| UserAddress | Required | HDR_016 | UserAddress is required |

#### Item Fields

| Field | Rule | Error Code | Message |
|-------|------|-----------|---------|
| ItemCode | Required | ITM_001 | ItemCode is required (Row {row}) |
| ItemCode | Max 50 chars | ITM_002 | ItemCode exceeds 50 characters (Row {row}) |
| ItemName | Required | ITM_003 | ItemName is required (Row {row}) |
| Qty | Required | ITM_004 | Qty is required (Row {row}) |
| Qty | > 0 | ITM_005 | Qty must be greater than 0 (Row {row}) |
| SerialText | Required | ITM_006 | SerialText is required (Row {row}) |
| SerialText Count | Match Qty | ITM_007 | SerialText count ({count}) does not match Qty ({qty}) (Row {row}) |
| Price | Required | ITM_008 | Price is required (Row {row}) |
| Price | ≥ 0 decimal | ITM_009 | Price must be ≥ 0 (Row {row}) |
| TotalPrice | Match Qty × Price | ITM_010 | TotalPrice should be {expected}, got {actual} (Row {row}) |

#### Address Fields

| Field | Rule | Error Code | Message |
|-------|------|-----------|---------|
| InstallDate | Required | ADDR_001 | InstallDate is required (Row {row}) |
| InstallDate | Format yyyy-MM-dd | ADDR_002 | InstallDate must be yyyy-MM-dd format (Row {row}) |
| Name | Required | ADDR_003 | Name is required (Row {row}) |
| Address | Required | ADDR_004 | Address is required (Row {row}) |
| Province | Required | ADDR_005 | Province is required (Row {row}) |
| Province | Valid ID | ADDR_006 | Province '{value}' not found (Row {row}) |
| District | Required | ADDR_007 | District is required (Row {row}) |
| District | Valid ID | ADDR_008 | District '{value}' not found for Province (Row {row}) |
| ContactName | Required | ADDR_009 | ContactName is required (Row {row}) |
| ContactTel | Required | ADDR_010 | ContactTel is required (Row {row}) |
| ContactTel | Phone format | ADDR_011 | ContactTel format invalid (Row {row}) |
| Qty | Required | ADDR_012 | Qty is required (Row {row}) |
| Qty | > 0 | ADDR_013 | Address Qty must be > 0 (Row {row}) |

#### PM Round Fields

| Field | Rule | Error Code | Message |
|-------|------|-----------|---------|
| Round | Range 1-21 | PM_001 | Round must be between 1 and 21 (Round {round}) |
| Round | Sequential | PM_002 | Rounds must be in sequential order (Round {round}) |
| RoundDate | Required | PM_003 | RoundDate is required (PM Round {round}) |
| RoundDate | Format yyyy-MM-dd | PM_004 | RoundDate must be yyyy-MM-dd format (PM Round {round}) |
| RoundDate | Ordered by date | PM_005 | PM Rounds must be ordered by date (Round {round}) |
| Package | Required | PM_006 | Package is required (PM Round {round}) |

### Cross-Field Validation

| Rule | Error Code | Message | Example |
|------|-----------|---------|---------|
| Item Count > 0 | VAL_001 | At least 1 item required | Must have ≥ 1 maintenance item |
| Address Count > 0 | VAL_002 | At least 1 install address required | Must have ≥ 1 installation address |
| PM Rounds ≥ 1 | VAL_003 | At least 1 PM round required | Must define ≥ PM round |
| PM Rounds ≤ 21 | VAL_004 | Maximum 21 PM rounds allowed | Cannot exceed 21 PM rounds |
| Serial Count in Items | VAL_005 | Serial item count mismatch | {item}: SerialText count ≠ Qty |

---

## 3. Data Enrichment Specification

### Lookup Operations

All lookups are performed **before** API calls to enrich data with IDs:

#### Province Lookup
```
Input: DealerProvinceName (STRING)
Process: Query Province table WHERE Name = input
Output: Province ID (INTEGER)
Cache: Yes, session-level cache
Error: ADDR_006 if not found
```

#### District Lookup
```
Input: DealerDistrictName (STRING) + DealerProvince (ID)
Process: Query District WHERE ProvinceID = input.Province AND Name = input
Output: District ID (INTEGER)
Cache: Yes, depends on Province
Error: ADDR_008 if not found
```

#### SubDistrict Lookup
```
Input: DealerSubDistrictName (STRING) + DealerDistrict (ID)
Process: Query SubDistrict WHERE DistrictID = input.District AND Name = input
Output: SubDistrict ID (INTEGER)
Cache: Yes, depends on District
Error: If not found, leave as NULL (optional field)
```

#### Zipcode Auto-Learn
```
Input: Province, District, SubDistrict IDs
Process: Query Zipcode table for exact match
Output: Zipcode (STRING) if found
Behavior: If found, populate empty field; if conflict with provided value, log warning
```

---

## 4. Import Response Specification

### Success Response (201 Created)

```json
{
  "success": true,
  "statusCode": 201,
  "message": "Maintenance Agreement imported successfully",
  "data": {
    "maintenanceID": 12345,
    "dealerID": 678,
    "userID": 679,
    "itemIDs": [1001, 1002, 1003],
    "addressIDs": [2001, 2002],
    "pmRoundIDs": [3001, 3002, 3003, 3004, 3005, 3006, 3007, 3008, 3009, 3010, 
                   3011, 3012, 3013, 3014, 3015, 3016, 3017, 3018, 3019, 3020, 3021]
  }
}
```

### Validation Error Response (400)

```json
{
  "success": false,
  "statusCode": 400,
  "message": "Validation failed. Please correct errors and resubmit.",
  "validationErrors": [
    {
      "field": "RunningNo",
      "message": "MA with RunningNo 'MA-2026-001' already exists",
      "section": "Header",
      "errorCode": "HDR_003",
      "rowNumber": 1,
      "columnNumber": 1
    },
    {
      "field": "SerialText",
      "message": "SerialText count (2) does not match Qty (3)",
      "section": "Items",
      "errorCode": "ITM_007",
      "rowNumber": 16,
      "columnNumber": 4
    }
  ],
  "errorDetails": "2 validation errors found"
}
```

### Data Lookup Error Response (422 Unprocessable Entity)

```json
{
  "success": false,
  "statusCode": 422,
  "message": "Cannot enrich import data. Reference lookups failed.",
  "validationErrors": [
    {
      "field": "DealerProvince",
      "message": "Province '999' not found in system",
      "section": "Header",
      "errorCode": "HDR_014",
      "rowNumber": 3,
      "columnNumber": 3
    }
  ],
  "errorDetails": "Province lookup failed"
}
```

### System Error Response (500)

```json
{
  "success": false,
  "statusCode": 500,
  "message": "An error occurred during import processing",
  "errorDetails": "Database connection timeout while creating maintenance record",
  "maintenanceID": null
}
```

---

## 5. Feature Constraints & Limits

| Constraint | Value | Reason |
|-----------|-------|--------|
| Max rows per import | 1000 | Performance / memory limits |
| Max Excel file size | 10 MB | File upload limits |
| Item quantity max | 999 | Database field constraint |
| PM rounds | 1-21 | Fixed business requirement |
| Serial per item max | 999 | Comma-separated parsing |
| Field max length | Per model definition | Ensure DB compatibility |
| Request timeout | 5 minutes | Large import operations |
| Concurrent imports | 1 per user | Prevent duplicate overwrites |

---

## 6. Localization Notes

**Language Support**: Thai (th-TH) primary, English (en-US) fallback

| Element | Thai | English |
|---------|------|---------|
| Error Messages | Localized | Default |
| Date Format | yyyy-MM-dd | yyyy-MM-dd |
| Decimal Separator | . (from Excel) | . (from Excel) |
| Province Names | Thai names in DB | Thai names in DB |

---

## 7. Security Specification

### Access Control
- **Endpoint**: Requires `[Authorize]` attribute
- **Role**: Must be MA Administrator or equivalent
- **CORS**: Enable if importing from external app

### Input Validation
- File type validation: Only `.xlsx` accepted
- File size validation: < 10 MB
- Content validation: No SQL injection in text fields
- Excel formula sanitization: Parse values only, ignore formulas

### Data Privacy
- No sensitive data logged (use ID references)
- Error messages don't expose internal IDs to user
- Uploaded files deleted after processing
- No file storage on server

---

**Specifications Complete**: ✓

