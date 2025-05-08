CREATE TABLE [PRO].[InvalidPanAadhar]
(
[SrNO] [int] NOT NULL IDENTITY(1, 1),
[DateOfData] [date] NULL,
[CustomerID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SourceSystemCustomerID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomerName] [varchar] (300) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SourceSystemName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PanNo] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AadharCard] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EffectiveFromTimekey] [int] NULL,
[EffectiveToTimeKey] [int] NULL
) ON [PRIMARY]
GO
