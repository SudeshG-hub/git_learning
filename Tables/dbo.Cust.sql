CREATE TABLE [dbo].[Cust]
(
[UCIC Code] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomerID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomerName] [varchar] (225) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AccountNo] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Host System Name] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OSBalance] [decimal] (16, 2) NULL,
[Report Date] [nvarchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ActSegmentCode] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Account Level Business Segment] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Business Seg Desc] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Base Account Scheme Code] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Base Account Scheme Owner] [int] NULL,
[Host System Status] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Remarks] [int] NULL,
[Closed Date] [int] NULL,
[Cr/Dr] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
