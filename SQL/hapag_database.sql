    -- Table structure for customer_addresses
    IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[customer_addresses]') AND type in (N'U'))
    BEGIN
    CREATE TABLE [dbo].[customer_addresses](
        [address_id] [int] IDENTITY(1,1) NOT NULL,
        [user_id] [int] NOT NULL,
        [address_name] [nvarchar](100) NULL,
        [recipient_name] [nvarchar](100) NOT NULL,
        [contact_number] [nvarchar](20) NOT NULL,
        [address_line] [nvarchar](255) NOT NULL,
        [city] [nvarchar](100) NOT NULL,
        [postal_code] [nvarchar](20) NULL,
        [is_default] [bit] NOT NULL DEFAULT 0,
        [date_added] [datetime] NOT NULL DEFAULT GETDATE(),
        CONSTRAINT [PK_customer_addresses] PRIMARY KEY CLUSTERED 
        (
            [address_id] ASC
        ),
        CONSTRAINT [FK_customer_addresses_users] FOREIGN KEY([user_id])
        REFERENCES [dbo].[users] ([user_id])
    )
    END
    GO 