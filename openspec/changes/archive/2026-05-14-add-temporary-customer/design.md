# Temporary Customer Feature - Technical Design

## Architecture Overview

The temporary customer feature extends the existing customer architecture with a simplified creation path that bypasses the approval workflow.

```
┌─────────────────┐    ┌──────────────────┐    ┌─────────────────┐
│   Expense UI    │────│  Temp Customer   │────│   CRM API       │
│                 │    │  Creation Modal  │    │                 │
│ - Add Button    │    │                  │    │ - New Endpoint  │
│ - Auto-Select   │    │ - Minimal Form   │    │ - Same Table    │
└─────────────────┘    └──────────────────┘    └─────────────────┘
```

## Data Model Changes

### Customer Table Extension
Add new fields to existing customer table:

```sql
ALTER TABLE Customer ADD COLUMN IsTemporary BIT NOT NULL DEFAULT 0;
ALTER TABLE Customer ADD COLUMN CreatedForExpenseId BIGINT NULL;
```

### Request/Response Models

**New Request Model:**
```csharp
// Models/Request/TempCustomerRequest.cs
public class TempCustomerRequest : BaseRequest
{
    public string? Branch { get; set; }
    public string? Type { get; set; }
    public string? Name { get; set; }
    public string? Address { get; set; }
    public int? Province { get; set; }
    public string? ProvinceName { get; set; }
    public int? District { get; set; }
    public string? DistrictName { get; set; }
    public int? SubDistrict { get; set; }
    public string? SubDistrictName { get; set; }
    public string? Zipcode { get; set; }
    public string? TaxID { get; set; }
    public string? Email { get; set; }
    public string? Tel { get; set; }
    public string? ContactName { get; set; }
    public string? ContactPosition { get; set; }
    public string? ContactEmail { get; set; }
    public string? ContactTel { get; set; }
    public string? ContactLineId { get; set; }
    public long? ExpenseId { get; set; } // Link to creating expense
}
```

**Response Model:**
```csharp
// Models/Response/TempCustomerResponse.cs
public class TempCustomerResponse : BaseResponse
{
    public TempCustomerData Data { get; set; }

    public class TempCustomerData
    {
        public long CustomerId { get; set; }
        public string CustomerCode { get; set; }
        public string CustomerName { get; set; }
    }
}
```

## API Design

### New Endpoint
```
POST /api/customer/v1/create-temporary
```

**Request Body:**
```json
{
  "name": "บริษัททดสอบจำกัด",
  "contactName": "สมชาย ใจดี",
  "contactPhone": "0812345678",
  "contactEmail": "test@example.com",
  "address": "123 ถนนสุขุมวิท",
  "expenseId": 123
}
```

**Response:**
```json
{
  "success": true,
  "data": {
    "customerId": 456,
    "customerCode": "TEMP20260514123456"
  }
}
```

### Code Generation Logic
```csharp
// Generate unique temporary customer code
string GenerateTempCustomerCode()
{
    return $"TEMP{DateTime.Now:yyyyMMddHHmmss}";
}
```

## Frontend Changes

### UI Modifications

**Expense Customer Partial (_Customer.cshtml):**
- Add "เพิ่มลูกค้าชั่วคราว" button next to search icon
- Create new modal `modal-add-temp-customer` with simplified form

**JavaScript Changes (detail.js):**
- Add click handler for temporary customer button
- Add save function that calls new API
- Auto-select created customer for current expense
- Update customer display fields

### Visual Design

**Button Placement:**
```html
<div class="d-flex">
    <input type="text" id="customer-company" class="form-control col" ... />
    <i class='bx bx-search m-2' ... data-bs-toggle="modal" data-bs-target="#modal-search-customer"></i>
    <button class="btn btn-outline-primary btn-sm ms-2" id="btn-add-temp-customer">
        เพิ่มลูกค้าชั่วคราว
    </button>
</div>
```

**Modal Structure:**
```html
<div class="modal fade" id="modal-add-temp-customer">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title">เพิ่มลูกค้าชั่วคราว</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
      </div>
      <div class="modal-body">
        <!-- Simplified form fields -->
        <div class="mb-3">
          <label class="form-label">ชื่อบริษัท *</label>
          <input type="text" id="temp-customer-name" class="form-control" required>
        </div>
        <div class="row">
          <div class="col-md-6">
            <label class="form-label">ชื่อผู้ติดต่อ</label>
            <input type="text" id="temp-customer-contact-name" class="form-control">
          </div>
          <div class="col-md-6">
            <label class="form-label">เบอร์โทร</label>
            <input type="text" id="temp-customer-contact-phone" class="form-control">
          </div>
        </div>
        <!-- Additional optional fields -->
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-primary" id="btn-save-temp-customer">บันทึก</button>
        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">ยกเลิก</button>
      </div>
    </div>
  </div>
</div>
```

## Search Integration

### Modified Search Results
Update customer search to include temporary customers with visual distinction:

```javascript
// In btn-search-customer click handler
// Add visual indicator for temporary customers
if (response.data[i].isTemporary) {
    td += `<td class="temp-customer-indicator">${d.name} <span class="badge bg-secondary">ชั่วคราว</span></td>`;
} else {
    td += `<td>${d.name}</td>`;
}
```

### CSS Styling
```css
/* Temporary customer visual distinction */
.temp-customer-row {
    background-color: #f8f9fa;
    border-left: 3px solid #6c757d;
}

.temp-customer-indicator .badge {
    font-size: 0.75em;
}
```

## Integration Points

### Expense Save Flow
- Temporary customers work with existing expense save logic
- No changes needed to expense creation/update endpoints
- Customer validation remains the same

### Contact Management
- Temporary customers can have contacts added via existing contact modal
- Contact creation logic unchanged

### Document Attachments
- Document upload functionality works for temporary customers
- No changes needed to document handling

## Error Handling

### Validation
- Company name is required
- Basic email format validation (if provided)
- Phone number format validation (if provided)

### API Error Responses
- Handle duplicate temporary customer names
- Handle database constraint violations
- Return appropriate error messages in Thai

## Testing Considerations

### Unit Tests
- API endpoint validation
- Code generation logic
- Model mapping

### Integration Tests
- End-to-end customer creation and selection
- Expense save with temporary customer
- Search functionality includes temporary customers

### UI Tests
- Modal opens correctly
- Form validation works
- Auto-selection after creation
- Visual distinction in search results
