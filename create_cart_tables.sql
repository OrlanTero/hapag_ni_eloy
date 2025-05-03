-- Create database if it doesn't exist
IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'FOS')
BEGIN
    CREATE DATABASE [FOS]
END
GO

USE [FOS]
GO

-- Create cart table if it doesn't exist
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[cart]') AND type in (N'U'))
BEGIN
    CREATE TABLE [dbo].[cart] (
        [cart_id] INT IDENTITY(1,1) PRIMARY KEY,
        [user_id] INT NOT NULL,
        [item_id] INT NOT NULL,
        [quantity] INT NOT NULL DEFAULT 1,
        CONSTRAINT [FK_cart_users] FOREIGN KEY ([user_id]) REFERENCES [dbo].[users] ([user_id]),
        CONSTRAINT [FK_cart_menu] FOREIGN KEY ([item_id]) REFERENCES [dbo].[menu] ([item_id])
    )
END
GO

-- Create orders table if it doesn't exist
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[orders]') AND type in (N'U'))
BEGIN
    CREATE TABLE [dbo].[orders] (
        [order_id] INT IDENTITY(1,1) PRIMARY KEY,
        [user_id] INT NOT NULL,
        [order_date] DATETIME NOT NULL DEFAULT GETDATE(),
        [status] VARCHAR(20) NOT NULL DEFAULT 'Pending',
        [total_amount] DECIMAL(10,2) NOT NULL DEFAULT 0,
        CONSTRAINT [FK_orders_users] FOREIGN KEY ([user_id]) REFERENCES [dbo].[users] ([user_id])
    )
END
GO

-- Create order_items table if it doesn't exist
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[order_items]') AND type in (N'U'))
BEGIN
    CREATE TABLE [dbo].[order_items] (
        [order_item_id] INT IDENTITY(1,1) PRIMARY KEY,
        [order_id] INT NOT NULL,
        [item_id] INT NOT NULL,
        [quantity] INT NOT NULL DEFAULT 1,
        [price] DECIMAL(10,2) NOT NULL,
        CONSTRAINT [FK_order_items_orders] FOREIGN KEY ([order_id]) REFERENCES [dbo].[orders] ([order_id]),
        CONSTRAINT [FK_order_items_menu] FOREIGN KEY ([item_id]) REFERENCES [dbo].[menu] ([item_id])
    )
END
GO 