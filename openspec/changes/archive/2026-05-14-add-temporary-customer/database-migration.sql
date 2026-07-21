-- Add temporary customer support to Customer table
-- This script should be run on the CRM backend database

-- Add IsTemporary column to identify temporary customers
ALTER TABLE Customer
ADD IsTemporary BIT NOT NULL DEFAULT 0;

-- Add CreatedForExpenseId to link temporary customers to their originating expense
ALTER TABLE Customer
ADD CreatedForExpenseId BIGINT NULL;

-- Add index for performance on temporary customer queries
CREATE INDEX IX_Customer_IsTemporary ON Customer (IsTemporary);

-- Add index for expense linking
CREATE INDEX IX_Customer_CreatedForExpenseId ON Customer (CreatedForExpenseId);

-- Add constraint to ensure CreatedForExpenseId is only set for temporary customers
ALTER TABLE Customer
ADD CONSTRAINT CK_Customer_TempExpenseLink
CHECK ((IsTemporary = 1 AND CreatedForExpenseId IS NOT NULL) OR (IsTemporary = 0 AND CreatedForExpenseId IS NULL));

PRINT 'Temporary customer columns added successfully';
