-- SQL Script to create base structure for FOS database
-- This script creates the basic tables needed for transactions, orders, and discounts

-- Create tables first (without foreign key constraints)

-- Create the discounts table if it doesn't exist
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'discounts')
BEGIN
    CREATE TABLE discounts (
        discount_id INT PRIMARY KEY IDENTITY(1,1),
        name NVARCHAR(100) NOT NULL,
        description NVARCHAR(MAX) NULL,
        discount_type INT NOT NULL, -- 1 for percentage, 2 for fixed amount
        value DECIMAL(10, 2) NOT NULL,
        applicable_products NVARCHAR(MAX) NULL, -- NULL for all products, or comma-separated item_ids
        start_date DATETIME NOT NULL,
        end_date DATETIME NOT NULL,
        min_order_amount DECIMAL(10, 2) NULL,
        status INT NOT NULL DEFAULT 1, -- 1 for active, 0 for inactive
        created_at DATETIME DEFAULT GETDATE(),
        updated_at DATETIME NULL
    );
    PRINT 'discounts table created successfully';
END

-- Create the transactions table if it doesn't exist
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'transactions')
BEGIN
    CREATE TABLE transactions (
        transaction_id INT PRIMARY KEY IDENTITY(1,1),
        user_id INT NOT NULL,
        payment_method NVARCHAR(50) NOT NULL,
        subtotal DECIMAL(10, 2) NOT NULL DEFAULT 0,
        discount DECIMAL(10, 2) NOT NULL DEFAULT 0,
        discount_id INT NULL,
        delivery_fee DECIMAL(10, 2) NOT NULL DEFAULT 0,
        delivery_type NVARCHAR(20) NOT NULL DEFAULT 'standard',
        scheduled_time DATETIME NULL,
        total_amount DECIMAL(10, 2) NOT NULL,
        status NVARCHAR(50) NOT NULL,
        payment_status NVARCHAR(20) NOT NULL DEFAULT 'Pending',
        reference_number NVARCHAR(50) NULL,
        sender_name NVARCHAR(100) NULL,
        sender_number NVARCHAR(20) NULL,
        created_at DATETIME DEFAULT GETDATE(),
        updated_at DATETIME NULL
    );
    PRINT 'transactions table created successfully';
END

-- Create the orders table if it doesn't exist
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'orders')
BEGIN
    CREATE TABLE orders (
        order_id INT PRIMARY KEY IDENTITY(1,1),
        user_id INT NOT NULL,
        transaction_id INT NULL, -- Allow NULL initially
        order_date DATETIME NOT NULL,
        subtotal DECIMAL(10, 2) NOT NULL DEFAULT 0,
        discount DECIMAL(10, 2) NOT NULL DEFAULT 0,
        delivery_fee DECIMAL(10, 2) NOT NULL DEFAULT 0,
        delivery_type NVARCHAR(20) NOT NULL DEFAULT 'standard',
        scheduled_time DATETIME NULL,
        total_amount DECIMAL(10, 2) NOT NULL,
        status NVARCHAR(50) NOT NULL,
        created_at DATETIME DEFAULT GETDATE(),
        updated_at DATETIME NULL
    );
    PRINT 'orders table created successfully';
END

-- Create the order_items table if it doesn't exist
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'order_items')
BEGIN
    CREATE TABLE order_items (
        order_item_id INT PRIMARY KEY IDENTITY(1,1),
        order_id INT NOT NULL,
        transaction_id INT NULL, -- Allow NULL initially
        item_id INT NOT NULL,
        quantity INT NOT NULL,
        price DECIMAL(10, 2) NOT NULL,
        created_at DATETIME DEFAULT GETDATE()
    );
    PRINT 'order_items table created successfully';
END

-- Now add foreign key constraints

-- First check if the discounts foreign key exists
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'transactions') 
AND EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'discounts')
BEGIN
    -- Check if constraint already exists
    IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.REFERENTIAL_CONSTRAINTS 
                   WHERE CONSTRAINT_NAME = 'FK_Transactions_Discounts')
    BEGIN
        ALTER TABLE transactions 
        ADD CONSTRAINT FK_Transactions_Discounts 
        FOREIGN KEY (discount_id) REFERENCES discounts(discount_id);
        
        PRINT 'Foreign key constraint added between transactions and discounts';
    END
END

-- Then check if the transactions foreign key exists
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'orders') 
AND EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'transactions')
BEGIN
    -- Check if constraint already exists
    IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.REFERENTIAL_CONSTRAINTS 
                   WHERE CONSTRAINT_NAME = 'FK_Orders_Transactions')
    BEGIN
        -- First ensure transaction_id column is NOT NULL
        IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS 
                  WHERE TABLE_NAME = 'orders' AND COLUMN_NAME = 'transaction_id' 
                  AND IS_NULLABLE = 'YES')
        BEGIN
            -- Update any NULL values if they exist
            UPDATE orders SET transaction_id = 1 WHERE transaction_id IS NULL;
            
            -- Make the column NOT NULL
            ALTER TABLE orders ALTER COLUMN transaction_id INT NOT NULL;
            PRINT 'Modified orders.transaction_id to NOT NULL';
        END
        
        -- Now add the foreign key constraint
        ALTER TABLE orders 
        ADD CONSTRAINT FK_Orders_Transactions 
        FOREIGN KEY (transaction_id) REFERENCES transactions(transaction_id);
        
        PRINT 'Foreign key constraint added between orders and transactions';
    END
END

-- Finally check if the orders foreign key exists
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'order_items') 
AND EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'orders')
BEGIN
    -- Check if constraint already exists
    IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.REFERENTIAL_CONSTRAINTS 
                   WHERE CONSTRAINT_NAME = 'FK_OrderItems_Orders')
    BEGIN
        ALTER TABLE order_items 
        ADD CONSTRAINT FK_OrderItems_Orders 
        FOREIGN KEY (order_id) REFERENCES orders(order_id);
        
        PRINT 'Foreign key constraint added between order_items and orders';
    END
END

-- Add transaction_id foreign key to order_items if needed
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'order_items') 
AND EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'transactions')
BEGIN
    -- Check if constraint already exists
    IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.REFERENTIAL_CONSTRAINTS 
                   WHERE CONSTRAINT_NAME = 'FK_OrderItems_Transactions')
    BEGIN
        -- First ensure transaction_id column is NOT NULL
        IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS 
                  WHERE TABLE_NAME = 'order_items' AND COLUMN_NAME = 'transaction_id' 
                  AND IS_NULLABLE = 'YES')
        BEGIN
            -- Update any NULL values if they exist
            UPDATE order_items SET transaction_id = 1 WHERE transaction_id IS NULL;
            
            -- Make the column NOT NULL
            ALTER TABLE order_items ALTER COLUMN transaction_id INT NOT NULL;
            PRINT 'Modified order_items.transaction_id to NOT NULL';
        END
        
        -- Now add the foreign key constraint
        ALTER TABLE order_items 
        ADD CONSTRAINT FK_OrderItems_Transactions 
        FOREIGN KEY (transaction_id) REFERENCES transactions(transaction_id);
        
        PRINT 'Foreign key constraint added between order_items and transactions';
    END
END

PRINT 'Database structure creation completed.' 