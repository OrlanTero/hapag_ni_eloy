USE [hapag_database]
GO

-- Check if the menu table exists
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[menu]') AND type in (N'U'))
BEGIN
    -- Check if no_of_serving column exists
    IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID(N'[dbo].[menu]') AND name = 'no_of_serving')
    BEGIN
        -- Add no_of_serving column if it doesn't exist
        ALTER TABLE [dbo].[menu] ADD [no_of_serving] [varchar](50) NULL
    END
END
GO 