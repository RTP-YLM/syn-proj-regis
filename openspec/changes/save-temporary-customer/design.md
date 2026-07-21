## Context

The application currently supports full customer creation with a complete workflow. Users entering customer data in expense or quotation forms may lose their input if interrupted. The proposal outlines adding a temporary save capability to prevent data loss and improve UX by allowing deferred completion.

Current state:
- CustomerController has create/update operations for persistent customer records
- Customer form is used in Expense and Quotation contexts
- No temporary or draft customer status exists in the data model

## Goals / Non-Goals

**Goals:**
- Enable users to save customer data without completing the full creation workflow
- Preserve temporary customer records in the database for later retrieval
- Allow users to resume, complete, or delete temporary customers
- Integrate seamlessly with existing customer forms without breaking current workflows

**Non-Goals:**
- Automatic cleanup of old temporary records (manual archival/deletion for now)
- Real-time collaboration or shared draft editing
- Version history or audit trail for temporary changes
- Mobile-specific UX for temporary customers

## Decisions

1. **Temporary Status Field**
   - Add a `Status` or `IsTemporary` field to the Customer entity
   - Decision: Use `Status` enum (Temporary, Active, Archived) for future extensibility
   - Rationale: More flexible than boolean; allows for other statuses later (Inactive, etc.)

2. **Storage Location**
   - Store temporary customers in the same Customer table with status differentiation
   - Decision: No separate table for temporary customers
   - Rationale: Simpler queries, easier migration to permanent status

3. **UI Button Placement**
   - Add "Save as Temporary" button in the customer form modal
   - Place it alongside or near the main "Save" button
   - Decision: Distinct button with different visual treatment (secondary button style)
   - Rationale: Clear separation of intent; prevents accidental temporary saves

4. **API Design**
   - Create POST endpoint: `/Customer/CreateTemporary` that accepts customer form data
   - Reuse existing Customer model validation where possible
   - Decision: Use same model but allow fewer required fields for temporary saves
   - Rationale: Reduces validation burden; doesn't require all mandatory fields for draft

5. **Response Handling**
   - Return saved customer ID and status to the UI
   - UI provides feedback: "Customer saved temporarily" with option to continue editing or view later
   - Decision: Redirect to temporary customer list or stay on form
   - Rationale: TBD based on UX testing; error handling clear for both paths

## Risks / Trade-offs

- **Risk**: Orphaned temporary records accumulate
  * Mitigation: Implement manual cleanup dashboard; eventually add auto-expiration policy

- **Risk**: Users confuse temporary saves with permanent ones
  * Mitigation: Clear UI labels and status indicators; show "Temporary" badge on records

- **Trade-off**: Looser validation for temporary saves reduces data quality initially
  * Benefit: Better UX during data entry; validation tightens on completion
  * Mitigation: Show validation hints even for non-required fields

- **Risk**: Performance impact if many temporary records accumulate
  * Mitigation: Index on Status field; implement archival/cleanup process

