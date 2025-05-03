USE [hapag_database]
GO

-- First, we need to drop foreign key constraints that will be affected by our changes
IF EXISTS (SELECT * FROM sys.foreign_keys WHERE name = 'FK_order_items_transactions')
BEGIN
    ALTER TABLE [dbo].[order_items] DROP CONSTRAINT [FK_order_items_transactions]
END
GO

-- Drop the index on order_items.transaction_id
IF EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_order_items_transaction_id')
BEGIN
    DROP INDEX [IX_order_items_transaction_id] ON [dbo].[order_items]
END
GO

-- Create a backup of existing orders table if needed
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'orders_backup')
BEGIN
    DROP TABLE [dbo].[orders_backup]
END
GO

SELECT * INTO [dbo].[orders_backup] FROM [dbo].[orders]
GO

-- Drop and recreate the orders table with correct columns
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'orders')
BEGIN
    DROP TABLE [dbo].[orders]
END
GO

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
    CONSTRAINT [PK_orders] PRIMARY KEY CLUSTERED ([order_id] ASC)
)
GO

-- Add foreign key constraint for user_id in orders table
ALTER TABLE [dbo].[orders] ADD CONSTRAINT [FK_orders_users] 
FOREIGN KEY([user_id]) REFERENCES [dbo].[users] ([user_id])
GO

-- Add foreign key constraint for transaction_id in orders table
ALTER TABLE [dbo].[orders] ADD CONSTRAINT [FK_orders_transactions] 
FOREIGN KEY([transaction_id]) REFERENCES [dbo].[transactions] ([transaction_id])
GO

-- Create an index on orders.user_id for better performance
CREATE NONCLUSTERED INDEX [IX_orders_user_id] ON [dbo].[orders] ([user_id] ASC)
GO

-- Create temporary table for existing order items
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'order_items_backup')
BEGIN
    DROP TABLE [dbo].[order_items_backup]
END
GO

SELECT * INTO [dbo].[order_items_backup] FROM [dbo].[order_items]
GO

-- Alter transaction_id column to allow NULL values
ALTER TABLE [dbo].[order_items] ALTER COLUMN [transaction_id] [int] NULL
GO

-- Add order_id column to order_items table
ALTER TABLE [dbo].[order_items] ADD [order_id] [int] NULL
GO

-- Add foreign key constraint for order_id in order_items table
ALTER TABLE [dbo].[order_items] ADD CONSTRAINT [FK_order_items_orders] 
FOREIGN KEY([order_id]) REFERENCES [dbo].[orders] ([order_id])
GO

-- Create an index on order_items.order_id for better performance
CREATE NONCLUSTERED INDEX [IX_order_items_order_id] ON [dbo].[order_items] ([order_id] ASC)
GO

-- Re-add foreign key constraint for transaction_id in order_items table
ALTER TABLE [dbo].[order_items] ADD CONSTRAINT [FK_order_items_transactions] 
FOREIGN KEY([transaction_id]) REFERENCES [dbo].[transactions] ([transaction_id])
GO

-- Re-create the index on order_items.transaction_id
CREATE NONCLUSTERED INDEX [IX_order_items_transaction_id] ON [dbo].[order_items] ([transaction_id] ASC)
GO

PRINT 'Database structure updated successfully.'
GO
