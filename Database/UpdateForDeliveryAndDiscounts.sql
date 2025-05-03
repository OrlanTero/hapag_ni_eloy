-- SQL Script to update tables for delivery options and discounts
-- Run this script to add the necessary columns to the transactions and orders tables

-- Check if discount_id column exists in transactions table
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'transactions' AND COLUMN_NAME = 'discount_id')
BEGIN
    ALTER TABLE transactions ADD discount_id INT NULL;
    ALTER TABLE transactions ADD CONSTRAINT FK_Transactions_Discounts FOREIGN KEY (discount_id) REFERENCES discounts(discount_id);
END

-- Check if subtotal column exists in transactions table
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'transactions' AND COLUMN_NAME = 'subtotal')
BEGIN
    ALTER TABLE transactions ADD subtotal DECIMAL(10, 2) NOT NULL DEFAULT 0;
END

-- Check if discount column exists in transactions table
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'transactions' AND COLUMN_NAME = 'discount')
BEGIN
    ALTER TABLE transactions ADD discount DECIMAL(10, 2) NOT NULL DEFAULT 0;
END

-- Check if delivery_fee column exists in transactions table
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'transactions' AND COLUMN_NAME = 'delivery_fee')
BEGIN
    ALTER TABLE transactions ADD delivery_fee DECIMAL(10, 2) NOT NULL DEFAULT 0;
END

-- Check if delivery_type column exists in transactions table
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'transactions' AND COLUMN_NAME = 'delivery_type')
BEGIN
    ALTER TABLE transactions ADD delivery_type NVARCHAR(20) NOT NULL DEFAULT 'standard';
END

-- Check if scheduled_time column exists in transactions table
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'transactions' AND COLUMN_NAME = 'scheduled_time')
BEGIN
    ALTER TABLE transactions ADD scheduled_time DATETIME NULL;
END

-- Check if payment_status column exists in transactions table (if not already added)
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'transactions' AND COLUMN_NAME = 'payment_status')
BEGIN
    ALTER TABLE transactions ADD payment_status NVARCHAR(20) NOT NULL DEFAULT 'Pending';
END

-- Update the orders table

-- Check if subtotal column exists in orders table
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'orders' AND COLUMN_NAME = 'subtotal')
BEGIN
    ALTER TABLE orders ADD subtotal DECIMAL(10, 2) NOT NULL DEFAULT 0;
END

-- Check if discount column exists in orders table
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'orders' AND COLUMN_NAME = 'discount')
BEGIN
    ALTER TABLE orders ADD discount DECIMAL(10, 2) NOT NULL DEFAULT 0;
END

-- Check if delivery_fee column exists in orders table
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'orders' AND COLUMN_NAME = 'delivery_fee')
BEGIN
    ALTER TABLE orders ADD delivery_fee DECIMAL(10, 2) NOT NULL DEFAULT 0;
END

-- Check if delivery_type column exists in orders table
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'orders' AND COLUMN_NAME = 'delivery_type')
BEGIN
    ALTER TABLE orders ADD delivery_type NVARCHAR(20) NOT NULL DEFAULT 'standard';
END

-- Check if scheduled_time column exists in orders table
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'orders' AND COLUMN_NAME = 'scheduled_time')
BEGIN
    ALTER TABLE orders ADD scheduled_time DATETIME NULL;
END

PRINT 'Database updated successfully with new columns for discounts and delivery options.' 