CREATE TABLE [CurDat].[AdvAcRecoveryDetailKCC_Balance]
(
[EntityKey] [bigint] NOT NULL IDENTITY(1, 1),
[BranchCode] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AccountEntityID] [int] NOT NULL,
[RefSystemACID] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RecAmt] [decimal] (16, 2) NULL,
[RecDate] [date] NOT NULL,
[DemandDate] [date] NULL,
[DemandAdj] [decimal] (16, 2) NULL,
[BalRecovery] [decimal] (16, 2) NULL,
[UnUsedRecAmt] [decimal] (16, 2) NULL,
[OrgRecAmt] [decimal] (16, 2) NULL
) ON [PRIMARY]
GO
