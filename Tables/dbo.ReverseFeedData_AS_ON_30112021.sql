CREATE TABLE [dbo].[ReverseFeedData_AS_ON_30112021]
(
[DateofData] [date] NULL,
[BranchCode] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomerID] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AccountID] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AssetClass] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AssetSubClass] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NPADate] [date] NULL,
[NPAReason] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LoanSeries] [smallint] NULL,
[LoanRefNo] [smallint] NULL,
[FundID] [varchar] (40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NPAStatus] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LoanRating] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OrgNPAStatus] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OrgLoanRating] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SourceAlt_Key] [int] NULL,
[SourceSystemName] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EffectiveFromTimeKey] [int] NULL,
[EffectiveToTimeKey] [int] NULL,
[UpgradeDate] [date] NULL,
[UCIF_ID] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ProductName] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DPD] [int] NULL,
[CustomerName] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
