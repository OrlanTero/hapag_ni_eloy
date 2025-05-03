-- Create discounts table
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'discounts')
BEGIN
    CREATE TABLE discounts (
        discount_id INT PRIMARY KEY IDENTITY(1,1),
        name NVARCHAR(100) NOT NULL,
        description NVARCHAR(MAX) NULL,
        discount_type INT NOT NULL, -- 1 for percentage, 2 for fixed amount
        value DECIMAL(10, 2) NOT NULL,
        applicable_products NVARCHAR(MAX) NULL,
        start_date DATETIME NOT NULL,
        end_date DATETIME NOT NULL,
        min_order_amount DECIMAL(10, 2) NULL,
        status INT NOT NULL DEFAULT 1, -- 1 for active, 0 for inactive
        created_at DATETIME DEFAULT GETDATE(),
        updated_at DATETIME NULL
    );
    PRINT 'discounts table created successfully';
END

-- Create transactions table
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

-- Run the UpdateForDeliveryAndDiscounts.sql script to add additional columns if needed
PRINT 'Database structure creation completed.' 