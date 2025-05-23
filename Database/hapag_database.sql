USE [master]
GO
/****** Object:  Database [hapag_database]    Script Date: 5/5/2025 1:56:00 AM ******/
CREATE DATABASE [hapag_database]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'hapag_database', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\DATA\hapag_database.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'hapag_database_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\DATA\hapag_database_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT, LEDGER = OFF
GO
ALTER DATABASE [hapag_database] SET COMPATIBILITY_LEVEL = 100
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [hapag_database].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [hapag_database] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [hapag_database] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [hapag_database] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [hapag_database] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [hapag_database] SET ARITHABORT OFF 
GO
ALTER DATABASE [hapag_database] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [hapag_database] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [hapag_database] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [hapag_database] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [hapag_database] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [hapag_database] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [hapag_database] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [hapag_database] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [hapag_database] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [hapag_database] SET  DISABLE_BROKER 
GO
ALTER DATABASE [hapag_database] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [hapag_database] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [hapag_database] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [hapag_database] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [hapag_database] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [hapag_database] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [hapag_database] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [hapag_database] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [hapag_database] SET  MULTI_USER 
GO
ALTER DATABASE [hapag_database] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [hapag_database] SET DB_CHAINING OFF 
GO
ALTER DATABASE [hapag_database] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [hapag_database] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [hapag_database] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [hapag_database] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
ALTER DATABASE [hapag_database] SET QUERY_STORE = ON
GO
ALTER DATABASE [hapag_database] SET QUERY_STORE (OPERATION_MODE = READ_WRITE, CLEANUP_POLICY = (STALE_QUERY_THRESHOLD_DAYS = 30), DATA_FLUSH_INTERVAL_SECONDS = 900, INTERVAL_LENGTH_MINUTES = 60, MAX_STORAGE_SIZE_MB = 1000, QUERY_CAPTURE_MODE = AUTO, SIZE_BASED_CLEANUP_MODE = AUTO, MAX_PLANS_PER_QUERY = 200, WAIT_STATS_CAPTURE_MODE = ON)
GO
USE [hapag_database]
GO
/****** Object:  Table [dbo].[cart]    Script Date: 5/5/2025 1:56:00 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[cart](
	[cart_id] [int] IDENTITY(1,1) NOT NULL,
	[user_id] [int] NOT NULL,
	[item_id] [int] NOT NULL,
	[quantity] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[cart_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[customer_addresses]    Script Date: 5/5/2025 1:56:00 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[customer_addresses](
	[address_id] [int] IDENTITY(1,1) NOT NULL,
	[user_id] [int] NOT NULL,
	[address_name] [nvarchar](100) NULL,
	[recipient_name] [nvarchar](100) NULL,
	[contact_number] [nvarchar](100) NULL,
	[address_line] [nvarchar](100) NULL,
	[city] [nvarchar](100) NULL,
	[postal_code] [nvarchar](100) NULL,
	[is_default] [bigint] NULL,
	[date_added] [datetime] NULL,
 CONSTRAINT [PK_customer_addresses] PRIMARY KEY CLUSTERED 
(
	[address_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[deals]    Script Date: 5/5/2025 1:56:00 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[deals](
	[deals_id] [int] IDENTITY(1,1) NOT NULL,
	[name] [varchar](50) NULL,
	[value] [varchar](50) NULL,
	[value_type] [varchar](50) NULL,
	[start_date] [varchar](50) NULL,
	[valid_until] [varchar](50) NULL,
	[date_created] [varchar](50) NULL,
	[description] [varchar](50) NULL,
	[image] [varchar](50) NULL,
 CONSTRAINT [PK_deals] PRIMARY KEY CLUSTERED 
(
	[deals_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[deals_item]    Script Date: 5/5/2025 1:56:00 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[deals_item](
	[deal_item_id] [int] IDENTITY(1,1) NOT NULL,
	[item_id] [varchar](50) NULL,
	[ref] [varchar](50) NULL,
	[date_created] [varchar](50) NULL,
 CONSTRAINT [PK_deals_item] PRIMARY KEY CLUSTERED 
(
	[deal_item_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[discounts]    Script Date: 5/5/2025 1:56:00 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[discounts](
	[discount_id] [int] IDENTITY(1,1) NOT NULL,
	[name] [varchar](50) NULL,
	[value] [varchar](50) NULL,
	[value_type] [varchar](50) NULL,
	[date_created] [varchar](50) NULL,
	[description] [varchar](50) NULL,
	[discount_type] [int] NOT NULL,
	[applicable_to] [int] NOT NULL,
	[start_date] [datetime] NOT NULL,
	[end_date] [datetime] NOT NULL,
	[min_order_amount] [decimal](10, 2) NULL,
	[status] [int] NOT NULL,
	[created_at] [datetime] NOT NULL,
 CONSTRAINT [PK_discounts] PRIMARY KEY CLUSTERED 
(
	[discount_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[login_history]    Script Date: 5/5/2025 1:56:00 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[login_history](
	[login_id] [int] IDENTITY(1,1) NOT NULL,
	[role] [varchar](50) NULL,
	[login_time] [datetime] NULL,
	[ip_address] [varchar](50) NULL,
	[user_id] [int] NULL,
 CONSTRAINT [PK_login_history] PRIMARY KEY CLUSTERED 
(
	[login_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[menu]    Script Date: 5/5/2025 1:56:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[menu](
	[item_id] [int] IDENTITY(1,1) NOT NULL,
	[name] [varchar](50) NULL,
	[price] [varchar](50) NULL,
	[category] [varchar](50) NULL,
	[type] [varchar](50) NULL,
	[availability] [varchar](50) NULL,
	[image] [varchar](255) NULL,
	[category_id] [int] NULL,
	[type_id] [int] NULL,
	[description] [varchar](255) NULL,
	[no_of_serving] [varchar](50) NULL,
 CONSTRAINT [PK_menu] PRIMARY KEY CLUSTERED 
(
	[item_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[menu_categories]    Script Date: 5/5/2025 1:56:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[menu_categories](
	[category_id] [int] IDENTITY(1,1) NOT NULL,
	[category_name] [varchar](50) NOT NULL,
	[description] [varchar](255) NULL,
	[is_active] [bit] NOT NULL,
 CONSTRAINT [PK_menu_categories] PRIMARY KEY CLUSTERED 
(
	[category_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[menu_types]    Script Date: 5/5/2025 1:56:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[menu_types](
	[type_id] [int] IDENTITY(1,1) NOT NULL,
	[type_name] [varchar](50) NOT NULL,
	[description] [varchar](255) NULL,
	[is_active] [bit] NOT NULL,
 CONSTRAINT [PK_menu_types] PRIMARY KEY CLUSTERED 
(
	[type_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[order_items]    Script Date: 5/5/2025 1:56:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[order_items](
	[order_item_id] [int] IDENTITY(1,1) NOT NULL,
	[transaction_id] [int] NOT NULL,
	[item_id] [int] NOT NULL,
	[quantity] [int] NOT NULL,
	[price] [decimal](10, 2) NOT NULL,
	[order_id] [int] NULL,
 CONSTRAINT [PK_order_items] PRIMARY KEY CLUSTERED 
(
	[order_item_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[order_items_backup]    Script Date: 5/5/2025 1:56:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[order_items_backup](
	[order_item_id] [int] IDENTITY(1,1) NOT NULL,
	[transaction_id] [int] NOT NULL,
	[item_id] [int] NOT NULL,
	[quantity] [int] NOT NULL,
	[price] [decimal](10, 2) NOT NULL,
	[order_id] [int] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[orders]    Script Date: 5/5/2025 1:56:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[orders](
	[order_id] [int] IDENTITY(1,1) NOT NULL,
	[user_id] [int] NOT NULL,
	[order_date] [datetime] NOT NULL,
	[transaction_id] [int] NULL,
	[subtotal] [varchar](50) NULL,
	[shipping_fee] [varchar](50) NULL,
	[tax] [varchar](50) NULL,
	[total_amount] [decimal](10, 2) NOT NULL,
	[status] [varchar](20) NOT NULL,
	[driver_name] [varchar](50) NULL,
	[delivery_service] [varchar](50) NULL,
	[tracking_link] [varchar](max) NULL,
	[delivery_notes] [varchar](500) NULL,
 CONSTRAINT [PK_orders] PRIMARY KEY CLUSTERED 
(
	[order_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[orders_backup]    Script Date: 5/5/2025 1:56:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[orders_backup](
	[item_id] [int] IDENTITY(1,1) NOT NULL,
	[subtotal] [varchar](50) NULL,
	[shipping_fee] [varchar](50) NULL,
	[tax] [varchar](50) NULL,
	[total_amount] [decimal](10, 2) NOT NULL,
	[status] [varchar](20) NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[promotions]    Script Date: 5/5/2025 1:56:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[promotions](
	[promotion_id] [int] IDENTITY(1,1) NOT NULL,
	[name] [varchar](50) NULL,
	[value] [varchar](50) NULL,
	[value_type] [varchar](50) NULL,
	[start_date] [varchar](50) NULL,
	[valid_until] [varchar](50) NULL,
	[date_created] [varchar](50) NULL,
	[description] [varchar](50) NULL,
	[image] [varchar](50) NULL,
	[code] [varchar](50) NULL,
	[min_purchase] [float] NULL,
	[is_active] [bigint] NULL,
 CONSTRAINT [PK_promotions] PRIMARY KEY CLUSTERED 
(
	[promotion_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[support_messages]    Script Date: 5/5/2025 1:56:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[support_messages](
	[message_id] [int] IDENTITY(1,1) NOT NULL,
	[ticket_id] [int] NOT NULL,
	[sender_id] [int] NOT NULL,
	[message_text] [nvarchar](max) NOT NULL,
	[attachment_url] [varchar](255) NULL,
	[is_read] [bit] NULL,
	[created_at] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[message_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[support_tickets]    Script Date: 5/5/2025 1:56:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[support_tickets](
	[ticket_id] [int] IDENTITY(1,1) NOT NULL,
	[user_id] [int] NOT NULL,
	[subject] [varchar](100) NOT NULL,
	[status] [varchar](20) NOT NULL,
	[priority] [varchar](10) NULL,
	[created_at] [datetime] NULL,
	[last_updated] [datetime] NULL,
	[assigned_staff_id] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[ticket_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[transactions]    Script Date: 5/5/2025 1:56:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[transactions](
	[transaction_id] [int] IDENTITY(1,1) NOT NULL,
	[payment_method] [varchar](50) NULL,
	[subtotal] [varchar](50) NULL,
	[total] [varchar](50) NULL,
	[discount] [varchar](50) NULL,
	[driver] [varchar](50) NULL,
	[user_id] [int] NOT NULL,
	[total_amount] [decimal](10, 2) NOT NULL,
	[status] [varchar](20) NOT NULL,
	[reference_number] [varchar](50) NULL,
	[sender_name] [varchar](100) NULL,
	[sender_number] [varchar](20) NULL,
	[transaction_date] [datetime] NOT NULL,
	[delivery_fee] [decimal](10, 2) NULL,
	[discount_id] [int] NULL,
	[promotion_id] [int] NULL,
	[deal_id] [int] NULL,
	[app_name] [varchar](100) NULL,
	[tracking_url] [varchar](100) NULL,
	[estimated_time] [varchar](100) NULL,
	[driver_name] [varchar](100) NULL,
	[verification_date] [datetime] NULL,
 CONSTRAINT [PK_transactions] PRIMARY KEY CLUSTERED 
(
	[transaction_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[users]    Script Date: 5/5/2025 1:56:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[users](
	[user_id] [int] IDENTITY(1,1) NOT NULL,
	[username] [varchar](50) NULL,
	[password] [varchar](50) NULL,
	[display_name] [varchar](50) NULL,
	[contact] [varchar](50) NULL,
	[email] [varchar](50) NULL,
	[address] [varchar](50) NULL,
	[user_type] [varchar](50) NULL,
 CONSTRAINT [PK_users] PRIMARY KEY CLUSTERED 
(
	[user_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[cart] ON 

INSERT [dbo].[cart] ([cart_id], [user_id], [item_id], [quantity]) VALUES (4, 2, 2, 2)
SET IDENTITY_INSERT [dbo].[cart] OFF
GO
SET IDENTITY_INSERT [dbo].[customer_addresses] ON 

INSERT [dbo].[customer_addresses] ([address_id], [user_id], [address_name], [recipient_name], [contact_number], [address_line], [city], [postal_code], [is_default], [date_added]) VALUES (1, 1, N'R10 Sitio Santo Ninio NBBS Navotas City', N'Jhon Orlan', N'0912345678', N'aw', N'Navotas', N'1485', 1, CAST(N'2025-05-04T14:32:25.000' AS DateTime))
SET IDENTITY_INSERT [dbo].[customer_addresses] OFF
GO
SET IDENTITY_INSERT [dbo].[discounts] ON 

INSERT [dbo].[discounts] ([discount_id], [name], [value], [value_type], [date_created], [description], [discount_type], [applicable_to], [start_date], [end_date], [min_order_amount], [status], [created_at]) VALUES (1, N'Senior Citizen', N'20', NULL, NULL, N'Mandatory 20% discount for senior citizens', 1, 1, CAST(N'2025-05-04T00:00:00.000' AS DateTime), CAST(N'2025-05-31T00:00:00.000' AS DateTime), CAST(0.00 AS Decimal(10, 2)), 1, CAST(N'2025-05-04T16:52:17.000' AS DateTime))
INSERT [dbo].[discounts] ([discount_id], [name], [value], [value_type], [date_created], [description], [discount_type], [applicable_to], [start_date], [end_date], [min_order_amount], [status], [created_at]) VALUES (2, N'PWD Discount', N'30', NULL, NULL, N'Mandatory 20% discount for persons with disability', 1, 1, CAST(N'2025-05-04T00:00:00.000' AS DateTime), CAST(N'2025-05-31T00:00:00.000' AS DateTime), CAST(0.00 AS Decimal(10, 2)), 1, CAST(N'2025-05-04T16:53:08.000' AS DateTime))
INSERT [dbo].[discounts] ([discount_id], [name], [value], [value_type], [date_created], [description], [discount_type], [applicable_to], [start_date], [end_date], [min_order_amount], [status], [created_at]) VALUES (3, N'Loyalty Discount', N'5', NULL, NULL, N'5% off for customers with 10+ previous orders', 1, 1, CAST(N'2025-05-04T00:00:00.000' AS DateTime), CAST(N'2025-05-24T00:00:00.000' AS DateTime), CAST(0.00 AS Decimal(10, 2)), 1, CAST(N'2025-05-04T16:53:36.000' AS DateTime))
INSERT [dbo].[discounts] ([discount_id], [name], [value], [value_type], [date_created], [description], [discount_type], [applicable_to], [start_date], [end_date], [min_order_amount], [status], [created_at]) VALUES (4, N'Bulk Order', N'200', NULL, NULL, N'?200 off for orders above ?2,000', 2, 1, CAST(N'2025-05-04T00:00:00.000' AS DateTime), CAST(N'2025-05-31T00:00:00.000' AS DateTime), CAST(0.00 AS Decimal(10, 2)), 1, CAST(N'2025-05-04T16:54:17.000' AS DateTime))
SET IDENTITY_INSERT [dbo].[discounts] OFF
GO
SET IDENTITY_INSERT [dbo].[login_history] ON 

INSERT [dbo].[login_history] ([login_id], [role], [login_time], [ip_address], [user_id]) VALUES (1, N'admin', CAST(N'2025-05-04T21:59:28.000' AS DateTime), N'::1', 2)
INSERT [dbo].[login_history] ([login_id], [role], [login_time], [ip_address], [user_id]) VALUES (2, N'admin', CAST(N'2025-05-04T22:16:38.000' AS DateTime), N'::1', 2)
INSERT [dbo].[login_history] ([login_id], [role], [login_time], [ip_address], [user_id]) VALUES (3, N'admin', CAST(N'2025-05-04T22:28:55.000' AS DateTime), N'::1', 2)
INSERT [dbo].[login_history] ([login_id], [role], [login_time], [ip_address], [user_id]) VALUES (4, N'admin', CAST(N'2025-05-04T23:01:14.000' AS DateTime), N'::1', 2)
INSERT [dbo].[login_history] ([login_id], [role], [login_time], [ip_address], [user_id]) VALUES (5, N'admin', CAST(N'2025-05-04T23:09:07.000' AS DateTime), N'::1', 2)
INSERT [dbo].[login_history] ([login_id], [role], [login_time], [ip_address], [user_id]) VALUES (6, N'admin', CAST(N'2025-05-04T23:12:43.000' AS DateTime), N'::1', 2)
INSERT [dbo].[login_history] ([login_id], [role], [login_time], [ip_address], [user_id]) VALUES (7, N'admin', CAST(N'2025-05-04T23:16:31.000' AS DateTime), N'::1', 2)
INSERT [dbo].[login_history] ([login_id], [role], [login_time], [ip_address], [user_id]) VALUES (8, N'admin', CAST(N'2025-05-04T23:18:28.000' AS DateTime), N'::1', 2)
INSERT [dbo].[login_history] ([login_id], [role], [login_time], [ip_address], [user_id]) VALUES (9, N'admin', CAST(N'2025-05-04T23:23:14.000' AS DateTime), N'::1', 2)
INSERT [dbo].[login_history] ([login_id], [role], [login_time], [ip_address], [user_id]) VALUES (10, N'admin', CAST(N'2025-05-04T23:29:51.000' AS DateTime), N'::1', 2)
INSERT [dbo].[login_history] ([login_id], [role], [login_time], [ip_address], [user_id]) VALUES (11, N'staff', CAST(N'2025-05-05T00:06:26.000' AS DateTime), N'::1', 3)
INSERT [dbo].[login_history] ([login_id], [role], [login_time], [ip_address], [user_id]) VALUES (12, N'staff', CAST(N'2025-05-05T00:17:11.000' AS DateTime), N'::1', 3)
INSERT [dbo].[login_history] ([login_id], [role], [login_time], [ip_address], [user_id]) VALUES (13, N'staff', CAST(N'2025-05-05T00:39:08.000' AS DateTime), N'::1', 3)
INSERT [dbo].[login_history] ([login_id], [role], [login_time], [ip_address], [user_id]) VALUES (14, N'staff', CAST(N'2025-05-05T00:43:49.000' AS DateTime), N'::1', 3)
INSERT [dbo].[login_history] ([login_id], [role], [login_time], [ip_address], [user_id]) VALUES (15, N'staff', CAST(N'2025-05-05T00:46:05.000' AS DateTime), N'::1', 3)
INSERT [dbo].[login_history] ([login_id], [role], [login_time], [ip_address], [user_id]) VALUES (16, N'staff', CAST(N'2025-05-05T01:09:19.000' AS DateTime), N'::1', 3)
INSERT [dbo].[login_history] ([login_id], [role], [login_time], [ip_address], [user_id]) VALUES (17, N'staff', CAST(N'2025-05-05T01:28:57.000' AS DateTime), N'::1', 3)
INSERT [dbo].[login_history] ([login_id], [role], [login_time], [ip_address], [user_id]) VALUES (18, N'staff', CAST(N'2025-05-05T01:34:20.000' AS DateTime), N'::1', 3)
INSERT [dbo].[login_history] ([login_id], [role], [login_time], [ip_address], [user_id]) VALUES (19, N'staff', CAST(N'2025-05-05T01:35:27.000' AS DateTime), N'::1', 3)
INSERT [dbo].[login_history] ([login_id], [role], [login_time], [ip_address], [user_id]) VALUES (20, N'staff', CAST(N'2025-05-05T01:40:21.000' AS DateTime), N'::1', 3)
INSERT [dbo].[login_history] ([login_id], [role], [login_time], [ip_address], [user_id]) VALUES (21, N'staff', CAST(N'2025-05-05T01:49:01.000' AS DateTime), N'::1', 3)
INSERT [dbo].[login_history] ([login_id], [role], [login_time], [ip_address], [user_id]) VALUES (22, N'staff', CAST(N'2025-05-05T01:50:47.000' AS DateTime), N'::1', 3)
SET IDENTITY_INSERT [dbo].[login_history] OFF
GO
SET IDENTITY_INSERT [dbo].[menu] ON 

INSERT [dbo].[menu] ([item_id], [name], [price], [category], [type], [availability], [image], [category_id], [type_id], [description], [no_of_serving]) VALUES (1, N'Kare Kare', N'1230', N'Main Dishes', N'Filipino Classics', N'1', NULL, 1, 1, N'', N'5')
INSERT [dbo].[menu] ([item_id], [name], [price], [category], [type], [availability], [image], [category_id], [type_id], [description], [no_of_serving]) VALUES (2, N'Adobong Manok', N'23', N'Main Dishes', N'Filipino Classics', N'1', NULL, 1, 1, N'aw', N'11')
SET IDENTITY_INSERT [dbo].[menu] OFF
GO
SET IDENTITY_INSERT [dbo].[menu_categories] ON 

INSERT [dbo].[menu_categories] ([category_id], [category_name], [description], [is_active]) VALUES (1, N'Main Dishes', N'Hearty entrees and complete meals', 1)
INSERT [dbo].[menu_categories] ([category_id], [category_name], [description], [is_active]) VALUES (2, N'Appetizers', N'Small dishes to start your meal', 1)
INSERT [dbo].[menu_categories] ([category_id], [category_name], [description], [is_active]) VALUES (3, N'Desserts', N'Sweet treats to finish your dining experience', 1)
INSERT [dbo].[menu_categories] ([category_id], [category_name], [description], [is_active]) VALUES (4, N'Beverages', N'Refreshing drinks and thirst quenchers', 1)
INSERT [dbo].[menu_categories] ([category_id], [category_name], [description], [is_active]) VALUES (5, N'Sides', N'Complementary dishes to accompany your meal', 1)
SET IDENTITY_INSERT [dbo].[menu_categories] OFF
GO
SET IDENTITY_INSERT [dbo].[menu_types] ON 

INSERT [dbo].[menu_types] ([type_id], [type_name], [description], [is_active]) VALUES (1, N'Filipino Classics', N'Enjoy Filipino cousines', 1)
INSERT [dbo].[menu_types] ([type_id], [type_name], [description], [is_active]) VALUES (2, N'Seafood Specialties', N'Fresh seafood prepared in various styles', 1)
INSERT [dbo].[menu_types] ([type_id], [type_name], [description], [is_active]) VALUES (3, N'Vegetarian Options', N'Delicious meals without meat', 1)
INSERT [dbo].[menu_types] ([type_id], [type_name], [description], [is_active]) VALUES (4, N'Signature Desserts', N'Our unique sweet creations
', 1)
INSERT [dbo].[menu_types] ([type_id], [type_name], [description], [is_active]) VALUES (5, N'House Blends', N'Special drink mixes exclusive to Hapag
', 1)
SET IDENTITY_INSERT [dbo].[menu_types] OFF
GO
SET IDENTITY_INSERT [dbo].[order_items] ON 

INSERT [dbo].[order_items] ([order_item_id], [transaction_id], [item_id], [quantity], [price], [order_id]) VALUES (1, 6, 1, 1, CAST(1230.00 AS Decimal(10, 2)), 1)
INSERT [dbo].[order_items] ([order_item_id], [transaction_id], [item_id], [quantity], [price], [order_id]) VALUES (2, 7, 2, 2, CAST(23.00 AS Decimal(10, 2)), 2)
INSERT [dbo].[order_items] ([order_item_id], [transaction_id], [item_id], [quantity], [price], [order_id]) VALUES (3, 8, 2, 1, CAST(23.00 AS Decimal(10, 2)), 3)
SET IDENTITY_INSERT [dbo].[order_items] OFF
GO
SET IDENTITY_INSERT [dbo].[orders] ON 

INSERT [dbo].[orders] ([order_id], [user_id], [order_date], [transaction_id], [subtotal], [shipping_fee], [tax], [total_amount], [status], [driver_name], [delivery_service], [tracking_link], [delivery_notes]) VALUES (1, 1, CAST(N'2025-05-04T15:13:31.373' AS DateTime), 6, N'1230', NULL, NULL, CAST(1230.00 AS Decimal(10, 2)), N'Payment Accepted', N'Orlan', N'Grab', N'awdawdaw', N'Delivery Type: standard. Discount: 0. Promotion: 0. Deal: 0')
INSERT [dbo].[orders] ([order_id], [user_id], [order_date], [transaction_id], [subtotal], [shipping_fee], [tax], [total_amount], [status], [driver_name], [delivery_service], [tracking_link], [delivery_notes]) VALUES (2, 1, CAST(N'2025-05-04T18:50:32.433' AS DateTime), 7, N'46', NULL, NULL, CAST(46.00 AS Decimal(10, 2)), N'processing', NULL, NULL, NULL, N'Delivery Type: standard. Discount: 0. Promotion: 0. Deal: 0')
INSERT [dbo].[orders] ([order_id], [user_id], [order_date], [transaction_id], [subtotal], [shipping_fee], [tax], [total_amount], [status], [driver_name], [delivery_service], [tracking_link], [delivery_notes]) VALUES (3, 1, CAST(N'2025-05-04T19:03:42.930' AS DateTime), 8, N'23', NULL, NULL, CAST(23.00 AS Decimal(10, 2)), N'Payment Accepted', NULL, NULL, NULL, N'Delivery Type: standard. Discount: 0. Promotion: 0. Deal: 0')
SET IDENTITY_INSERT [dbo].[orders] OFF
GO
SET IDENTITY_INSERT [dbo].[promotions] ON 

INSERT [dbo].[promotions] ([promotion_id], [name], [value], [value_type], [start_date], [valid_until], [date_created], [description], [image], [code], [min_purchase], [is_active]) VALUES (1, N'New Customer Welcome', N'15', N'1', N'5/4/2025', N'7/31/2025', N'2025-05-04 16:56:11', N'15% off on your first order', N'', N'Well100', 0, 0)
INSERT [dbo].[promotions] ([promotion_id], [name], [value], [value_type], [start_date], [valid_until], [date_created], [description], [image], [code], [min_purchase], [is_active]) VALUES (2, N'WEEKEND SPECIAL', N'100', N'2', N'5/4/2025', N'7/31/2025', N'2025-05-04 17:01:52', N'?100 off on orders above ?800 during weekends', N'', N'WEEKEND100', 0, 0)
SET IDENTITY_INSERT [dbo].[promotions] OFF
GO
SET IDENTITY_INSERT [dbo].[support_messages] ON 

INSERT [dbo].[support_messages] ([message_id], [ticket_id], [sender_id], [message_text], [attachment_url], [is_read], [created_at]) VALUES (1, 1, 1, N'yey', NULL, 1, CAST(N'2025-05-05T01:27:38.010' AS DateTime))
INSERT [dbo].[support_messages] ([message_id], [ticket_id], [sender_id], [message_text], [attachment_url], [is_read], [created_at]) VALUES (2, 1, 3, N'aww', NULL, 1, CAST(N'2025-05-05T01:40:34.700' AS DateTime))
INSERT [dbo].[support_messages] ([message_id], [ticket_id], [sender_id], [message_text], [attachment_url], [is_read], [created_at]) VALUES (3, 1, 3, N'aw', NULL, 1, CAST(N'2025-05-05T01:50:54.147' AS DateTime))
INSERT [dbo].[support_messages] ([message_id], [ticket_id], [sender_id], [message_text], [attachment_url], [is_read], [created_at]) VALUES (4, 1, 3, N'isa pa', NULL, 1, CAST(N'2025-05-05T01:54:00.217' AS DateTime))
INSERT [dbo].[support_messages] ([message_id], [ticket_id], [sender_id], [message_text], [attachment_url], [is_read], [created_at]) VALUES (5, 1, 1, N'haa', NULL, 0, CAST(N'2025-05-05T01:54:12.900' AS DateTime))
SET IDENTITY_INSERT [dbo].[support_messages] OFF
GO
SET IDENTITY_INSERT [dbo].[support_tickets] ON 

INSERT [dbo].[support_tickets] ([ticket_id], [user_id], [subject], [status], [priority], [created_at], [last_updated], [assigned_staff_id]) VALUES (1, 1, N'AWdawd', N'In Progress', N'Medium', CAST(N'2025-05-05T01:21:58.150' AS DateTime), CAST(N'2025-05-05T01:54:12.903' AS DateTime), 3)
SET IDENTITY_INSERT [dbo].[support_tickets] OFF
GO
SET IDENTITY_INSERT [dbo].[transactions] ON 

INSERT [dbo].[transactions] ([transaction_id], [payment_method], [subtotal], [total], [discount], [driver], [user_id], [total_amount], [status], [reference_number], [sender_name], [sender_number], [transaction_date], [delivery_fee], [discount_id], [promotion_id], [deal_id], [app_name], [tracking_url], [estimated_time], [driver_name], [verification_date]) VALUES (1, N'cash', N'1230', NULL, N'0', NULL, 1, CAST(1230.00 AS Decimal(10, 2)), N'Pending', NULL, NULL, NULL, CAST(N'2025-05-04T14:44:10.897' AS DateTime), CAST(0.00 AS Decimal(10, 2)), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[transactions] ([transaction_id], [payment_method], [subtotal], [total], [discount], [driver], [user_id], [total_amount], [status], [reference_number], [sender_name], [sender_number], [transaction_date], [delivery_fee], [discount_id], [promotion_id], [deal_id], [app_name], [tracking_url], [estimated_time], [driver_name], [verification_date]) VALUES (2, N'cash', N'1230', NULL, N'0', NULL, 1, CAST(1230.00 AS Decimal(10, 2)), N'Pending', NULL, NULL, NULL, CAST(N'2025-05-04T14:45:22.733' AS DateTime), CAST(0.00 AS Decimal(10, 2)), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[transactions] ([transaction_id], [payment_method], [subtotal], [total], [discount], [driver], [user_id], [total_amount], [status], [reference_number], [sender_name], [sender_number], [transaction_date], [delivery_fee], [discount_id], [promotion_id], [deal_id], [app_name], [tracking_url], [estimated_time], [driver_name], [verification_date]) VALUES (3, N'cash', N'1230', NULL, N'0', NULL, 1, CAST(1230.00 AS Decimal(10, 2)), N'Pending', NULL, NULL, NULL, CAST(N'2025-05-04T14:50:25.907' AS DateTime), CAST(0.00 AS Decimal(10, 2)), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[transactions] ([transaction_id], [payment_method], [subtotal], [total], [discount], [driver], [user_id], [total_amount], [status], [reference_number], [sender_name], [sender_number], [transaction_date], [delivery_fee], [discount_id], [promotion_id], [deal_id], [app_name], [tracking_url], [estimated_time], [driver_name], [verification_date]) VALUES (4, N'cash', N'1230', NULL, N'0', NULL, 1, CAST(1230.00 AS Decimal(10, 2)), N'Pending', NULL, NULL, NULL, CAST(N'2025-05-04T14:51:03.180' AS DateTime), CAST(0.00 AS Decimal(10, 2)), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[transactions] ([transaction_id], [payment_method], [subtotal], [total], [discount], [driver], [user_id], [total_amount], [status], [reference_number], [sender_name], [sender_number], [transaction_date], [delivery_fee], [discount_id], [promotion_id], [deal_id], [app_name], [tracking_url], [estimated_time], [driver_name], [verification_date]) VALUES (5, N'gcash', N'1230', NULL, N'0', NULL, 1, CAST(1230.00 AS Decimal(10, 2)), N'Pending', NULL, NULL, NULL, CAST(N'2025-05-04T14:55:26.827' AS DateTime), CAST(0.00 AS Decimal(10, 2)), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[transactions] ([transaction_id], [payment_method], [subtotal], [total], [discount], [driver], [user_id], [total_amount], [status], [reference_number], [sender_name], [sender_number], [transaction_date], [delivery_fee], [discount_id], [promotion_id], [deal_id], [app_name], [tracking_url], [estimated_time], [driver_name], [verification_date]) VALUES (6, N'gcash', N'1230', NULL, N'0', NULL, 1, CAST(1230.00 AS Decimal(10, 2)), N'Verified', NULL, NULL, NULL, CAST(N'2025-05-04T15:13:31.327' AS DateTime), CAST(0.00 AS Decimal(10, 2)), NULL, NULL, NULL, N'Grab', N'awdawdaw', N'30 Minutes', NULL, CAST(N'2025-05-04T20:46:41.000' AS DateTime))
INSERT [dbo].[transactions] ([transaction_id], [payment_method], [subtotal], [total], [discount], [driver], [user_id], [total_amount], [status], [reference_number], [sender_name], [sender_number], [transaction_date], [delivery_fee], [discount_id], [promotion_id], [deal_id], [app_name], [tracking_url], [estimated_time], [driver_name], [verification_date]) VALUES (7, N'gcash', N'46', NULL, N'0', NULL, 1, CAST(46.00 AS Decimal(10, 2)), N'Pending', NULL, NULL, NULL, CAST(N'2025-05-04T18:50:32.403' AS DateTime), CAST(0.00 AS Decimal(10, 2)), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[transactions] ([transaction_id], [payment_method], [subtotal], [total], [discount], [driver], [user_id], [total_amount], [status], [reference_number], [sender_name], [sender_number], [transaction_date], [delivery_fee], [discount_id], [promotion_id], [deal_id], [app_name], [tracking_url], [estimated_time], [driver_name], [verification_date]) VALUES (8, N'gcash', N'23', NULL, N'0', NULL, 1, CAST(23.00 AS Decimal(10, 2)), N'Verified', N'1234567890', N'awda', N'09334612603', CAST(N'2025-05-04T19:03:42.903' AS DateTime), CAST(0.00 AS Decimal(10, 2)), NULL, NULL, NULL, NULL, NULL, NULL, NULL, CAST(N'2025-05-04T21:26:42.000' AS DateTime))
SET IDENTITY_INSERT [dbo].[transactions] OFF
GO
SET IDENTITY_INSERT [dbo].[users] ON 

INSERT [dbo].[users] ([user_id], [username], [password], [display_name], [contact], [email], [address], [user_type]) VALUES (1, N'customer', N'123456', N'Customer', N'091234759', NULL, N'AR12345432423', N'3')
INSERT [dbo].[users] ([user_id], [username], [password], [display_name], [contact], [email], [address], [user_type]) VALUES (2, N'admin', N'123456', N'Administrator', N'12345677', N'admin@gmail.com', N'Admin Address', N'1')
INSERT [dbo].[users] ([user_id], [username], [password], [display_name], [contact], [email], [address], [user_type]) VALUES (3, N'staff', N'123456', N'Staff', N'1234666', N'staff@gmail.com', N'Staff', N'2')
SET IDENTITY_INSERT [dbo].[users] OFF
GO
/****** Object:  Index [IX_cart_user_id]    Script Date: 5/5/2025 1:56:01 AM ******/
CREATE NONCLUSTERED INDEX [IX_cart_user_id] ON [dbo].[cart]
(
	[user_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_order_items_order_id]    Script Date: 5/5/2025 1:56:01 AM ******/
CREATE NONCLUSTERED INDEX [IX_order_items_order_id] ON [dbo].[order_items]
(
	[order_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_order_items_transaction_id]    Script Date: 5/5/2025 1:56:01 AM ******/
CREATE NONCLUSTERED INDEX [IX_order_items_transaction_id] ON [dbo].[order_items]
(
	[transaction_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_orders_user_id]    Script Date: 5/5/2025 1:56:01 AM ******/
CREATE NONCLUSTERED INDEX [IX_orders_user_id] ON [dbo].[orders]
(
	[user_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [idx_ticket_id]    Script Date: 5/5/2025 1:56:01 AM ******/
CREATE NONCLUSTERED INDEX [idx_ticket_id] ON [dbo].[support_messages]
(
	[ticket_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [idx_staff_tickets]    Script Date: 5/5/2025 1:56:01 AM ******/
CREATE NONCLUSTERED INDEX [idx_staff_tickets] ON [dbo].[support_tickets]
(
	[assigned_staff_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [idx_user_tickets]    Script Date: 5/5/2025 1:56:01 AM ******/
CREATE NONCLUSTERED INDEX [idx_user_tickets] ON [dbo].[support_tickets]
(
	[user_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_transactions_user_id]    Script Date: 5/5/2025 1:56:01 AM ******/
CREATE NONCLUSTERED INDEX [IX_transactions_user_id] ON [dbo].[transactions]
(
	[user_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[cart] ADD  DEFAULT ((1)) FOR [quantity]
GO
ALTER TABLE [dbo].[discounts] ADD  DEFAULT ((1)) FOR [discount_type]
GO
ALTER TABLE [dbo].[discounts] ADD  DEFAULT ((1)) FOR [applicable_to]
GO
ALTER TABLE [dbo].[discounts] ADD  DEFAULT (getdate()) FOR [start_date]
GO
ALTER TABLE [dbo].[discounts] ADD  DEFAULT (dateadd(month,(1),getdate())) FOR [end_date]
GO
ALTER TABLE [dbo].[discounts] ADD  DEFAULT ((1)) FOR [status]
GO
ALTER TABLE [dbo].[discounts] ADD  DEFAULT (getdate()) FOR [created_at]
GO
ALTER TABLE [dbo].[menu_categories] ADD  DEFAULT ((1)) FOR [is_active]
GO
ALTER TABLE [dbo].[menu_types] ADD  DEFAULT ((1)) FOR [is_active]
GO
ALTER TABLE [dbo].[order_items] ADD  DEFAULT ((1)) FOR [quantity]
GO
ALTER TABLE [dbo].[orders] ADD  CONSTRAINT [DF__orders__order_da__35BCFE0A]  DEFAULT (getdate()) FOR [order_date]
GO
ALTER TABLE [dbo].[orders] ADD  CONSTRAINT [DF__orders__total_am__36B12243]  DEFAULT ((0)) FOR [total_amount]
GO
ALTER TABLE [dbo].[orders] ADD  CONSTRAINT [DF__orders__status__37A5467C]  DEFAULT ('pending') FOR [status]
GO
ALTER TABLE [dbo].[support_messages] ADD  DEFAULT ((0)) FOR [is_read]
GO
ALTER TABLE [dbo].[support_messages] ADD  DEFAULT (getdate()) FOR [created_at]
GO
ALTER TABLE [dbo].[support_tickets] ADD  DEFAULT ('Medium') FOR [priority]
GO
ALTER TABLE [dbo].[support_tickets] ADD  DEFAULT (getdate()) FOR [created_at]
GO
ALTER TABLE [dbo].[support_tickets] ADD  DEFAULT (getdate()) FOR [last_updated]
GO
ALTER TABLE [dbo].[transactions] ADD  DEFAULT ((1)) FOR [user_id]
GO
ALTER TABLE [dbo].[transactions] ADD  DEFAULT ((0)) FOR [total_amount]
GO
ALTER TABLE [dbo].[transactions] ADD  DEFAULT ('Pending') FOR [status]
GO
ALTER TABLE [dbo].[transactions] ADD  DEFAULT (getdate()) FOR [transaction_date]
GO
ALTER TABLE [dbo].[cart]  WITH CHECK ADD FOREIGN KEY([item_id])
REFERENCES [dbo].[menu] ([item_id])
GO
ALTER TABLE [dbo].[cart]  WITH CHECK ADD FOREIGN KEY([user_id])
REFERENCES [dbo].[users] ([user_id])
GO
ALTER TABLE [dbo].[menu]  WITH CHECK ADD  CONSTRAINT [FK_menu_menu_categories] FOREIGN KEY([category_id])
REFERENCES [dbo].[menu_categories] ([category_id])
GO
ALTER TABLE [dbo].[menu] CHECK CONSTRAINT [FK_menu_menu_categories]
GO
ALTER TABLE [dbo].[menu]  WITH CHECK ADD  CONSTRAINT [FK_menu_menu_types] FOREIGN KEY([type_id])
REFERENCES [dbo].[menu_types] ([type_id])
GO
ALTER TABLE [dbo].[menu] CHECK CONSTRAINT [FK_menu_menu_types]
GO
ALTER TABLE [dbo].[order_items]  WITH CHECK ADD  CONSTRAINT [FK_order_items_menu] FOREIGN KEY([item_id])
REFERENCES [dbo].[menu] ([item_id])
GO
ALTER TABLE [dbo].[order_items] CHECK CONSTRAINT [FK_order_items_menu]
GO
ALTER TABLE [dbo].[order_items]  WITH CHECK ADD  CONSTRAINT [FK_order_items_orders] FOREIGN KEY([order_id])
REFERENCES [dbo].[orders] ([order_id])
GO
ALTER TABLE [dbo].[order_items] CHECK CONSTRAINT [FK_order_items_orders]
GO
ALTER TABLE [dbo].[order_items]  WITH CHECK ADD  CONSTRAINT [FK_order_items_transactions] FOREIGN KEY([transaction_id])
REFERENCES [dbo].[transactions] ([transaction_id])
GO
ALTER TABLE [dbo].[order_items] CHECK CONSTRAINT [FK_order_items_transactions]
GO
ALTER TABLE [dbo].[orders]  WITH CHECK ADD  CONSTRAINT [FK_orders_transactions] FOREIGN KEY([transaction_id])
REFERENCES [dbo].[transactions] ([transaction_id])
GO
ALTER TABLE [dbo].[orders] CHECK CONSTRAINT [FK_orders_transactions]
GO
ALTER TABLE [dbo].[orders]  WITH CHECK ADD  CONSTRAINT [FK_orders_users] FOREIGN KEY([user_id])
REFERENCES [dbo].[users] ([user_id])
GO
ALTER TABLE [dbo].[orders] CHECK CONSTRAINT [FK_orders_users]
GO
ALTER TABLE [dbo].[support_messages]  WITH CHECK ADD FOREIGN KEY([sender_id])
REFERENCES [dbo].[users] ([user_id])
GO
ALTER TABLE [dbo].[support_messages]  WITH CHECK ADD FOREIGN KEY([ticket_id])
REFERENCES [dbo].[support_tickets] ([ticket_id])
GO
ALTER TABLE [dbo].[support_tickets]  WITH CHECK ADD FOREIGN KEY([assigned_staff_id])
REFERENCES [dbo].[users] ([user_id])
GO
ALTER TABLE [dbo].[support_tickets]  WITH CHECK ADD FOREIGN KEY([user_id])
REFERENCES [dbo].[users] ([user_id])
GO
ALTER TABLE [dbo].[transactions]  WITH CHECK ADD  CONSTRAINT [FK_transactions_users] FOREIGN KEY([user_id])
REFERENCES [dbo].[users] ([user_id])
GO
ALTER TABLE [dbo].[transactions] CHECK CONSTRAINT [FK_transactions_users]
GO
USE [master]
GO
ALTER DATABASE [hapag_database] SET  READ_WRITE 
GO
