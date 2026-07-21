# Temporary Customer Creation

## Overview
The temporary customer creation feature allows users to quickly create customers with minimal information for use in expense claims, bypassing the full customer approval workflow.

## Functional Requirements

### TC-001: Temporary Customer Creation
**As an** expense claim creator  
**I want to** create a temporary customer with minimal information  
**So that** I can quickly associate customers with expenses without going through full approval process

**Acceptance Criteria:**
- Company name is required
- Contact information (name, phone, email) is optional
- Address is optional
- Customer is automatically selected for current expense after creation
- Customer appears in search results with visual distinction

### TC-002: Visual Distinction
**As an** expense claim creator  
**I want to** easily distinguish temporary customers from permanent customers  
**So that** I know which customers are temporary

**Acceptance Criteria:**
- Temporary customers show "ชั่วคราว" badge in search results
- Temporary customers have different row styling (gray background, border)
- Code format is "TEMP" + timestamp

### TC-003: Customer Selection
**As an** expense claim creator  
**I want to** select temporary customers like permanent customers  
**So that** the workflow is consistent

**Acceptance Criteria:**
- Temporary customers appear in customer search results
- Clicking "เลือก" button works the same for temporary and permanent customers
- Customer information displays correctly in readonly fields

## Non-Functional Requirements

### TC-004: Performance
- Temporary customer creation should complete within 2 seconds
- Search results should include temporary customers without performance degradation
- No impact on existing customer search performance

### TC-005: Data Integrity
- Temporary customers are stored in same table with IsTemporary flag
- All existing customer functionality works with temporary customers
- No data loss or corruption during creation or selection

## Business Rules

### BR-001: Temporary Customer Lifecycle
- Temporary customers can be reused across multiple expenses
- No automatic cleanup or expiration
- Can be converted to permanent customers (future enhancement)

### BR-002: Code Generation
- Format: TEMP + YYYYMMDDHHMMSS
- Unique across all customers
- No collision with permanent customer codes

### BR-003: Validation Rules
- Company name: Required, max 255 characters
- Contact name: Optional, max 100 characters
- Phone: Optional, valid Thai phone format if provided
- Email: Optional, valid email format if provided
- Address: Optional, max 500 characters

## Integration Requirements

### IR-001: Expense Integration
- Temporary customers work with existing expense save functionality
- Customer ID is properly linked to expense records
- Contact management works for temporary customers

### IR-002: Search Integration
- Temporary customers included in customer search API
- Search results include IsTemporary flag for UI distinction
- No changes needed to existing search endpoints

## Error Handling

### EH-001: Validation Errors
- Required field missing: "กรุณาระบุชื่อบริษัท"
- Invalid email format: "รูปแบบอีเมล์ไม่ถูกต้อง"
- Invalid phone format: "รูปแบบเบอร์โทรไม่ถูกต้อง"

### EH-002: API Errors
- Duplicate name: "มีชื่อบริษัทนี้อยู่ในระบบแล้ว"
- Database error: "เกิดข้อผิดพลาดในการบันทึกข้อมูล"
- Network error: "ไม่สามารถเชื่อมต่อกับเซิร์ฟเวอร์ได้"

## Future Enhancements

### FE-001: Customer Conversion
Allow temporary customers to be converted to permanent customers with full approval workflow.

### FE-002: Bulk Operations
Allow creation of multiple temporary customers at once.

### FE-003: Customer Cleanup
Automatic cleanup of unused temporary customers after certain period.
