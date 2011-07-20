CREATE DATABASE [BookingDB]
GO

USE [BookingDB]
GO

/****** Object:  Table [dbo].[User]    Script Date: 01/29/2011 12:04:05 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[User](
	[uid] [int] IDENTITY(1,1) NOT NULL,
	[account] [nchar](50) NOT NULL,
	[passwd] [nchar](40) NOT NULL,
	[realname] [nchar](10) NULL,
	[balance] [numeric](18, 2) NOT NULL,
	[enabled] [bit] NOT NULL,
	[type] [int] NOT NULL,
 CONSTRAINT [PK_User] PRIMARY KEY CLUSTERED 
(
	[uid] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[User] ADD  CONSTRAINT [DF_User_enabled]  DEFAULT ((1)) FOR [enabled]
GO

ALTER TABLE [dbo].[User] ADD  CONSTRAINT [DF_User_balance]  DEFAULT ((0)) FOR [balance]
GO

CREATE TABLE [dbo].[Trade](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[shopid] [int] NOT NULL,
	[tradename] [nchar](20) NOT NULL,
	[tradevalue] [decimal](18, 2) NOT NULL,
 CONSTRAINT [PK_Trade] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

CREATE TABLE [dbo].[Shop](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[shopname] [nchar](20) NOT NULL,
	[phone] [nchar](20) NULL,
 CONSTRAINT [PK_Shop] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

CREATE TABLE [dbo].[Deduction](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[uid] [int] NOT NULL,
	[realname] [nchar](10) NOT NULL,
	[shopid] [int] NOT NULL,
	[shopname] [nchar](20) NOT NULL,
	[deductionname] [nchar](100) NOT NULL,
	[deductionvalue] [decimal](18, 2) NOT NULL,
	[deductioncount] [int] NOT NULL,
	[deductionbalance] [decimal](18, 2) NULL,
	[deductiontime] [datetime] NOT NULL,
	[remarks] [nchar](100) NULL,
 CONSTRAINT [PK_Deduction] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[Deduction] ADD  CONSTRAINT [DF_Deduction_deductiontime]  DEFAULT (getdate()) FOR [deductiontime]
GO

CREATE TABLE [dbo].[BookingTrade](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[bookingshopid] [int] NOT NULL,
	[bookingid] [int] NOT NULL,
	[bookingname] [nchar](50) NOT NULL,
	[shopid] [int] NOT NULL,
	[shopname] [nchar](20) NOT NULL,
	[handlerid] [int] NOT NULL,
	[handlername] [nchar](10) NOT NULL,
	[proxyid] [int] NOT NULL,
	[proxyname] [nchar](10) NOT NULL,
	[uid] [int] NOT NULL,
	[realname] [nchar](10) NOT NULL,
	[tradeid] [int] NOT NULL,
	[tradename] [nchar](20) NOT NULL,
	[tradevalue] [decimal](18, 2) NOT NULL,
	[tradecount] [int] NOT NULL,
	[issettle] [bit] NOT NULL,
	[bookinttime] [datetime] NOT NULL,
	[remarks] [nchar](100) NOT NULL,
 CONSTRAINT [PK_BookingTrade] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[BookingTrade] ADD  CONSTRAINT [DF_BookingTrade_issettle]  DEFAULT ((0)) FOR [issettle]
GO

ALTER TABLE [dbo].[BookingTrade] ADD  CONSTRAINT [DF_BookingTrade_bookinttime]  DEFAULT (getdate()) FOR [bookinttime]
GO

CREATE TABLE [dbo].[BookingShop](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[bookingid] [int] NOT NULL,
	[bookingname] [nchar](20) NOT NULL,
	[uid] [int] NOT NULL,
	[realname] [nchar](10) NOT NULL,
	[shopid] [int] NOT NULL,
	[shopname] [nchar](20) NOT NULL,
	[begintime] [datetime] NOT NULL,
	[isover] [bit] NOT NULL,
 CONSTRAINT [PK_BookingShop] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[BookingShop] ADD  CONSTRAINT [DF_BookingShop_begintime]  DEFAULT (getdate()) FOR [begintime]
GO

CREATE TABLE [dbo].[Booking](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[uid] [int] NOT NULL,
	[realname] [nchar](10) NOT NULL,
	[bookingname] [nchar](50) NOT NULL,
	[bookingtime] [datetime] NOT NULL,
	[isbooking] [bit] NOT NULL,
	[issettle] [bit] NULL,
	[haserror] [bit] NULL,
 CONSTRAINT [PK_Booking] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[Booking] ADD  CONSTRAINT [DF_Booking_bookingtime]  DEFAULT (getdate()) FOR [bookingtime]
GO

ALTER TABLE [dbo].[Booking] ADD  CONSTRAINT [DF_Booking_isbooking]  DEFAULT ((1)) FOR [isbooking]
GO

CREATE TABLE [dbo].[Balance](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[uid] [int] NOT NULL,
	[balances] [decimal](18, 2) NULL,
	[btime] [datetime] NOT NULL,
	[remarks] [nchar](200) NULL,
 CONSTRAINT [PK_Balance] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[Balance] ADD  CONSTRAINT [DF_Balance_btime]  DEFAULT (getdate()) FOR [btime]
GO

CREATE TABLE [dbo].[App](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[isinstall] [bit] NOT NULL,
 CONSTRAINT [PK_App] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

