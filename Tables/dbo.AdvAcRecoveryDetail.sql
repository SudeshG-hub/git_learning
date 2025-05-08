CREATE TABLE [dbo].[AdvAcRecoveryDetail]
(
[EntityKey] [int] NOT NULL IDENTITY(1, 1),
[BranchCode] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AccountEntityID] [int] NOT NULL,
[RefSystemACID] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AcType] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RecAmt] [decimal] (16, 2) NULL,
[RecDate] [date] NOT NULL,
[CashRecDate] [date] NOT NULL,
[DemandDate] [date] NULL,
[DemandAdj] [decimal] (16, 2) NULL,
[BalRecovery] [decimal] (16, 2) NULL,
[RecSchNumber] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreatedBy] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateCreated] [date] NULL
) ON [PRIMARY]
GO
