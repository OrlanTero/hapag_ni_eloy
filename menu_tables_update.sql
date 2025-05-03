USE [hapag_database]
GO

-- Create menu_categories table
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[menu_categories]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[menu_categories](
    [category_id] [int] IDENTITY(1,1) NOT NULL,
    [category_name] [varchar](50) NOT NULL,
    [description] [varchar](255) NULL,
    [is_active] [bit] NOT NULL DEFAULT 1,
 CONSTRAINT [PK_menu_categories] PRIMARY KEY CLUSTERED 
(
    [category_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO

-- Create menu_types table
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[menu_types]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[menu_types](
    [type_id] [int] IDENTITY(1,1) NOT NULL,
    [type_name] [varchar](50) NOT NULL,
    [description] [varchar](255) NULL,
    [is_active] [bit] NOT NULL DEFAULT 1,
 CONSTRAINT [PK_menu_types] PRIMARY KEY CLUSTERED 
(
    [type_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO

-- Modify menu table to add foreign keys and additional fields
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[menu]') AND type in (N'U'))
BEGIN
    -- Check if columns exist and add them if they don't
    IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID(N'[dbo].[menu]') AND name = 'item_id')
    BEGIN
        -- Rename user_id to item_id
        EXEC sp_rename 'menu.user_id', 'item_id', 'COLUMN'
    END

    IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID(N'[dbo].[menu]') AND name = 'name')
    BEGIN
        -- Rename product_name to name if it exists
        IF EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID(N'[dbo].[menu]') AND name = 'product_name')
        BEGIN
            EXEC sp_rename 'menu.product_name', 'name', 'COLUMN'
        END
        ELSE
        BEGIN
            -- Add name column if product_name doesn't exist
            ALTER TABLE [dbo].[menu] ADD [name] [varchar](100) NULL
        END
    END

    -- Add category_id if it doesn't exist
    IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID(N'[dbo].[menu]') AND name = 'category_id')
    BEGIN
        ALTER TABLE [dbo].[menu] ADD [category_id] [int] NULL
    END

    -- Add type_id if it doesn't exist
    IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID(N'[dbo].[menu]') AND name = 'type_id')
    BEGIN
        ALTER TABLE [dbo].[menu] ADD [type_id] [int] NULL
    END

    -- Add category if it doesn't exist (for backward compatibility)
    IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID(N'[dbo].[menu]') AND name = 'category')
    BEGIN
        ALTER TABLE [dbo].[menu] ADD [category] [varchar](50) NULL
    END

    -- Add type if it doesn't exist (for backward compatibility)
    IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID(N'[dbo].[menu]') AND name = 'type')
    BEGIN
        ALTER TABLE [dbo].[menu] ADD [type] [varchar](50) NULL
    END

    -- Add availability if it doesn't exist
    IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID(N'[dbo].[menu]') AND name = 'availability')
    BEGIN
        ALTER TABLE [dbo].[menu] ADD [availability] [varchar](50) NULL
    END

    -- Add image if it doesn't exist
    IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID(N'[dbo].[menu]') AND name = 'image')
    BEGIN
        ALTER TABLE [dbo].[menu] ADD [image] [varchar](255) NULL
    END

    -- Add description if it doesn't exist
    IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID(N'[dbo].[menu]') AND name = 'description')
    BEGIN
        ALTER TABLE [dbo].[menu] ADD [description] [varchar](255) NULL
    END
END
GO

-- Add foreign key constraints
IF EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID(N'[dbo].[menu]') AND name = 'category_id')
AND EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[menu_categories]') AND type in (N'U'))
AND NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_menu_menu_categories]'))
BEGIN
    ALTER TABLE [dbo].[menu] WITH CHECK ADD CONSTRAINT [FK_menu_menu_categories] FOREIGN KEY([category_id])
    REFERENCES [dbo].[menu_categories] ([category_id])
END
GO

IF EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID(N'[dbo].[menu]') AND name = 'type_id')
AND EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[menu_types]') AND type in (N'U'))
AND NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_menu_menu_types]'))
BEGIN
    ALTER TABLE [dbo].[menu] WITH CHECK ADD CONSTRAINT [FK_menu_menu_types] FOREIGN KEY([type_id])
    REFERENCES [dbo].[menu_types] ([type_id])
END
GO

-- Insert default categories
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[menu_categories]') AND type in (N'U'))
BEGIN
    IF NOT EXISTS (SELECT * FROM [dbo].[menu_categories] WHERE [category_name] = 'Breakfast')
    BEGIN
        INSERT INTO [dbo].[menu_categories] ([category_name], [description]) VALUES ('Breakfast', 'Morning meals and breakfast items')
    END

    IF NOT EXISTS (SELECT * FROM [dbo].[menu_categories] WHERE [category_name] = 'Lunch')
    BEGIN
        INSERT INTO [dbo].[menu_categories] ([category_name], [description]) VALUES ('Lunch', 'Midday meals and lunch specials')
    END

    IF NOT EXISTS (SELECT * FROM [dbo].[menu_categories] WHERE [category_name] = 'Dinner')
    BEGIN
        INSERT INTO [dbo].[menu_categories] ([category_name], [description]) VALUES ('Dinner', 'Evening meals and dinner options')
    END

    IF NOT EXISTS (SELECT * FROM [dbo].[menu_categories] WHERE [category_name] = 'Drinks')
    BEGIN
        INSERT INTO [dbo].[menu_categories] ([category_name], [description]) VALUES ('Drinks', 'Beverages and refreshments')
    END

    IF NOT EXISTS (SELECT * FROM [dbo].[menu_categories] WHERE [category_name] = 'Dessert')
    BEGIN
        INSERT INTO [dbo].[menu_categories] ([category_name], [description]) VALUES ('Dessert', 'Sweet treats and desserts')
    END
END
GO

-- Insert default types
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[menu_types]') AND type in (N'U'))
BEGIN
    IF NOT EXISTS (SELECT * FROM [dbo].[menu_types] WHERE [type_name] = 'Appetizer')
    BEGIN
        INSERT INTO [dbo].[menu_types] ([type_name], [description]) VALUES ('Appetizer', 'Starters and small plates')
    END

    IF NOT EXISTS (SELECT * FROM [dbo].[menu_types] WHERE [type_name] = 'Main Course')
    BEGIN
        INSERT INTO [dbo].[menu_types] ([type_name], [description]) VALUES ('Main Course', 'Primary dishes')
    END

    IF NOT EXISTS (SELECT * FROM [dbo].[menu_types] WHERE [type_name] = 'Side Dish')
    BEGIN
        INSERT INTO [dbo].[menu_types] ([type_name], [description]) VALUES ('Side Dish', 'Accompaniments and side orders')
    END

    IF NOT EXISTS (SELECT * FROM [dbo].[menu_types] WHERE [type_name] = 'Beverage')
    BEGIN
        INSERT INTO [dbo].[menu_types] ([type_name], [description]) VALUES ('Beverage', 'Drinks and refreshments')
    END

    IF NOT EXISTS (SELECT * FROM [dbo].[menu_types] WHERE [type_name] = 'Dessert')
    BEGIN
        INSERT INTO [dbo].[menu_types] ([type_name], [description]) VALUES ('Dessert', 'Sweet treats and desserts')
    END
END
GO 