-- SQL Script to update existing tables with needed columns
-- This is a safe script that checks if columns exist before adding them

-- Get orders table structure
PRINT 'Updating orders table...';

-- Check if user_id column exists in orders table
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'orders' AND COLUMN_NAME = 'user_id')
BEGIN
    ALTER TABLE orders ADD user_id INT NOT NULL DEFAULT 1;
    PRINT 'Added user_id column to orders table';
END

-- Check if transaction_id column exists in orders table
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'orders' AND COLUMN_NAME = 'transaction_id')
BEGIN
    ALTER TABLE orders ADD transaction_id INT NULL;
    PRINT 'Added transaction_id column to orders table';
END

-- Check if order_date column exists in orders table
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'orders' AND COLUMN_NAME = 'order_date')
BEGIN
    ALTER TABLE orders ADD order_date DATETIME NOT NULL DEFAULT GETDATE();
    PRINT 'Added order_date column to orders table';
END

-- Check if subtotal column exists in orders table
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'orders' AND COLUMN_NAME = 'subtotal')
BEGIN
    ALTER TABLE orders ADD subtotal DECIMAL(10, 2) NOT NULL DEFAULT 0;
    PRINT 'Added subtotal column to orders table';
END

-- Check if discount column exists in orders table
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'orders' AND COLUMN_NAME = 'discount')
BEGIN
    ALTER TABLE orders ADD discount DECIMAL(10, 2) NOT NULL DEFAULT 0;
    PRINT 'Added discount column to orders table';
END

-- Check if delivery_fee column exists in orders table
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'orders' AND COLUMN_NAME = 'delivery_fee')
BEGIN
    ALTER TABLE orders ADD delivery_fee DECIMAL(10, 2) NOT NULL DEFAULT 0;
    PRINT 'Added delivery_fee column to orders table';
END

-- Check if delivery_type column exists in orders table
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'orders' AND COLUMN_NAME = 'delivery_type')
BEGIN
    ALTER TABLE orders ADD delivery_type NVARCHAR(20) NOT NULL DEFAULT 'standard';
    PRINT 'Added delivery_type column to orders table';
END

-- Check if scheduled_time column exists in orders table
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'orders' AND COLUMN_NAME = 'scheduled_time')
BEGIN
    ALTER TABLE orders ADD scheduled_time DATETIME NULL;
    PRINT 'Added scheduled_time column to orders table';
END

-- Check if total_amount column exists in orders table
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'orders' AND COLUMN_NAME = 'total_amount')
BEGIN
    ALTER TABLE orders ADD total_amount DECIMAL(10, 2) NOT NULL DEFAULT 0;
    PRINT 'Added total_amount column to orders table';
END

-- Check if status column exists in orders table
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'orders' AND COLUMN_NAME = 'status')
BEGIN
    ALTER TABLE orders ADD status NVARCHAR(50) NOT NULL DEFAULT 'pending';
    PRINT 'Added status column to orders table';
END

-- Get order_items table structure
PRINT 'Updating order_items table...';

-- Check if order_id column exists in order_items table
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'order_items' AND COLUMN_NAME = 'order_id')
BEGIN
    ALTER TABLE order_items ADD order_id INT NOT NULL DEFAULT 1;
    PRINT 'Added order_id column to order_items table';
END

-- Check if transaction_id column exists in order_items table
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'order_items' AND COLUMN_NAME = 'transaction_id')
BEGIN
    ALTER TABLE order_items ADD transaction_id INT NULL;
    PRINT 'Added transaction_id column to order_items table';
END

-- Check if item_id column exists in order_items table
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'order_items' AND COLUMN_NAME = 'item_id')
BEGIN
    ALTER TABLE order_items ADD item_id INT NOT NULL DEFAULT 1;
    PRINT 'Added item_id column to order_items table';
END

-- Check if quantity column exists in order_items table
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'order_items' AND COLUMN_NAME = 'quantity')
BEGIN
    ALTER TABLE order_items ADD quantity INT NOT NULL DEFAULT 1;
    PRINT 'Added quantity column to order_items table';
END

-- Check if price column exists in order_items table
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'order_items' AND COLUMN_NAME = 'price')
BEGIN
    ALTER TABLE order_items ADD price DECIMAL(10, 2) NOT NULL DEFAULT 0;
    PRINT 'Added price column to order_items table';
END

PRINT 'Database table updates completed.'; 