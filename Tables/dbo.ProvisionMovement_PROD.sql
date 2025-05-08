CREATE TABLE [dbo].[ProvisionMovement_PROD]
(
[ProvisionProcessDate] [datetime] NULL,
[Timekey] [int] NULL,
[SourceAlt_Key] [int] NULL,
[BranchCode] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomerID] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomerEntityID] [int] NULL,
[CustomerAcid] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AccountEntityID] [int] NULL,
[CustomerName] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MovementNature] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[InitialAssetClassAlt_Key] [int] NULL,
[InitialProvision] [decimal] (18, 2) NULL,
[ExistingProvision_Addition] [decimal] (18, 2) NULL,
[FreshProvision_Addition] [decimal] (18, 2) NULL,
[ReductionDuetoUpgradeProvision] [decimal] (18, 2) NULL,
[ReductionProvisionDuetoWrite_Off] [decimal] (18, 2) NULL,
[ReductionDuetoRecovery_ExistingProvision] [decimal] (18, 2) NULL,
[ReductionProvisionDuetoRecovery_Arcs] [decimal] (18, 2) NULL,
[FinalAssetClassAlt_Key] [int] NULL,
[FinalProvision] [decimal] (18, 2) NULL,
[TotalAddition_Provision] [decimal] (18, 2) NULL,
[TotalReduction_Provision] [decimal] (18, 2) NULL,
[MovementStatus] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ProvisionReason] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Movement_Flag] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
