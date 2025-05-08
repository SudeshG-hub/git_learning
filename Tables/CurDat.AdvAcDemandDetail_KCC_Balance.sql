CREATE TABLE [CurDat].[AdvAcDemandDetail_KCC_Balance]
(
[EntityKey] [bigint] NOT NULL IDENTITY(1, 1),
[BranchCode] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AccountEntityID] [int] NOT NULL,
[DemandType] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TxnDate] [date] NULL,
[DemandDate] [date] NOT NULL,
[DemandOverDueDate] [date] NULL,
[DemandAmt] [decimal] (16, 2) NULL,
[RecDate] [date] NULL,
[RecAdjDate] [date] NULL,
[RecAmount] [decimal] (16, 2) NULL,
[BalanceDemand] [decimal] (16, 2) NULL,
[DmdSchNumber] [varchar] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RefSystemACID] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AcType] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DmdGenNum] [varchar] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TxnTag_AltKey] [tinyint] NULL,
[EffectiveFromTimeKey] [int] NULL,
[EffectiveToTimeKey] [int] NULL,
[CreatedBy] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateCreated] [datetime] NULL,
[UnUsedDmdAmt] [decimal] (16, 2) NULL,
[OrgDemandAmt] [decimal] (16, 2) NULL
) ON [PRIMARY]
GO
