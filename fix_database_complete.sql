USE [hapag_database]
GO

-- Backup existing data
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'orders_backup')
BEGIN
    DROP TABLE [dbo].[orders_backup]
END
GO

SELECT * INTO [dbo].[orders_backup] FROM [dbo].[orders]
GO

IF EXISTS (SELECT * FROM sys.tables WHERE name = 'order_items_backup')
BEGIN
    DROP TABLE [dbo].[order_items_backup]
END
GO

SELECT * INTO [dbo].[order_items_backup] FROM [dbo].[order_items]
GO

-- Drop constraints first
IF EXISTS (SELECT * FROM sys.foreign_keys WHERE name = 'FK_order_items_transactions')
BEGIN
    ALTER TABLE [dbo].[order_items] DROP CONSTRAINT [FK_order_items_transactions]
END
GO

IF EXISTS (SELECT * FROM sys.foreign_keys WHERE name = 'FK_order_items_menu')
BEGIN
    ALTER TABLE [dbo].[order_items] DROP CONSTRAINT [FK_order_items_menu]
END
GO

IF EXISTS (SELECT * FROM sys.foreign_keys WHERE name = 'FK_order_items_orders')
BEGIN
    ALTER TABLE [dbo].[order_items] DROP CONSTRAINT [FK_order_items_orders]
END
GO

-- Drop indexes
IF EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_order_items_transaction_id')
BEGIN
    DROP INDEX [IX_order_items_transaction_id] ON [dbo].[order_items]
END
GO

IF EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_order_items_order_id')
BEGIN
    DROP INDEX [IX_order_items_order_id] ON [dbo].[order_items]
END
GO

-- Drop and recreate order_items table first (to avoid dependency issues)
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'order_items')
BEGIN
    DROP TABLE [dbo].[order_items]
END
GO

-- Drop and recreate the orders table with correct columns
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'orders')
BEGIN
    DROP TABLE [dbo].[orders]
END
GO

-- Create new orders table
CREATE TABLE [dbo].[orders](
    [order_id] [int] IDENTITY(1,1) NOT NULL,
    [user_id] [int] NOT NULL,
    [order_date] [datetime] NOT NULL DEFAULT GETDATE(),
    [transaction_id] [int] NULL,
    [subtotal] [varchar](50) NULL,
    [shipping_fee] [varchar](50) NULL,
    [tax] [varchar](50) NULL,
    [total_amount] [decimal](10, 2) NOT NULL DEFAULT 0,
    [status] [varchar](20) NOT NULL DEFAULT 'pending',
    [driver_name] [varchar](100) NULL,
    [delivery_service] [varchar](50) NULL,
    [tracking_link] [varchar](255) NULL,
    [delivery_notes] [varchar](500) NULL,
    CONSTRAINT [PK_orders] PRIMARY KEY CLUSTERED ([order_id] ASC)
)
GO

-- Create new order_items table
CREATE TABLE [dbo].[order_items](
    [order_item_id] [int] IDENTITY(1,1) NOT NULL,
    [order_id] [int] NOT NULL,
    [transaction_id] [int] NULL,
    [item_id] [int] NOT NULL,
    [quantity] [int] NOT NULL DEFAULT 1,
    [price] [decimal](10, 2) NOT NULL,
    CONSTRAINT [PK_order_items] PRIMARY KEY CLUSTERED ([order_item_id] ASC)
)
GO

-- Add foreign key constraints
ALTER TABLE [dbo].[orders] ADD CONSTRAINT [FK_orders_users] 
FOREIGN KEY([user_id]) REFERENCES [dbo].[users] ([user_id])
GO

ALTER TABLE [dbo].[orders] ADD CONSTRAINT [FK_orders_transactions] 
FOREIGN KEY([transaction_id]) REFERENCES [dbo].[transactions] ([transaction_id])
GO

ALTER TABLE [dbo].[order_items] ADD CONSTRAINT [FK_order_items_orders] 
FOREIGN KEY([order_id]) REFERENCES [dbo].[orders] ([order_id])
GO

ALTER TABLE [dbo].[order_items] ADD CONSTRAINT [FK_order_items_menu] 
FOREIGN KEY([item_id]) REFERENCES [dbo].[menu] ([item_id])
GO

ALTER TABLE [dbo].[order_items] ADD CONSTRAINT [FK_order_items_transactions] 
FOREIGN KEY([transaction_id]) REFERENCES [dbo].[transactions] ([transaction_id])
GO

-- Create indexes for performance
CREATE NONCLUSTERED INDEX [IX_orders_user_id] ON [dbo].[orders] ([user_id] ASC)
GO

CREATE NONCLUSTERED INDEX [IX_orders_transaction_id] ON [dbo].[orders] ([transaction_id] ASC)
GO

CREATE NONCLUSTERED INDEX [IX_order_items_order_id] ON [dbo].[order_items] ([order_id] ASC)
GO

CREATE NONCLUSTERED INDEX [IX_order_items_item_id] ON [dbo].[order_items] ([item_id] ASC)
GO

CREATE NONCLUSTERED INDEX [IX_order_items_transaction_id] ON [dbo].[order_items] ([transaction_id] ASC)
GO

-- Migrate existing data if possible
-- Note: This part will only work if the old data can be mapped to the new structure
-- This is just a placeholder and may need adjustments
/*
BEGIN TRY
    -- Insert sample order
    DECLARE @user_id INT = 1 -- Replace with actual user ID
    
    INSERT INTO [dbo].[orders] 
        ([user_id], [order_date], [status], [total_amount])
    VALUES 
        (@user_id, GETDATE(), 'pending', 0)
    
    DECLARE @new_order_id INT = SCOPE_IDENTITY()
    
    -- Insert sample order items
    INSERT INTO [dbo].[order_items]
        ([order_id], [item_id], [quantity], [price])
    VALUES
        (@new_order_id, 1, 2, 199.99)
END TRY
BEGIN CATCH
    PRINT 'Error migrating data: ' + ERROR_MESSAGE()
END CATCH
*/

PRINT 'Database structure updated successfully.'
GO 