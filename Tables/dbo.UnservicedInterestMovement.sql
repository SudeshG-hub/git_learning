CREATE TABLE [dbo].[UnservicedInterestMovement]
(
[UnservicedInterestProcessDate] [datetime] NULL,
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
[InitialUnservicedInterest] [decimal] (18, 2) NULL,
[ExistingUnservicedInterest_Addition] [decimal] (18, 2) NULL,
[FreshUnservicedInterest_Addition] [decimal] (18, 2) NULL,
[ReductionDuetoUpgradeUnservicedInterest] [decimal] (18, 2) NULL,
[ReductionUnservicedInterestDuetoWrite_Off] [decimal] (18, 2) NULL,
[ReductionDuetoRecovery_ExistingUnservicedInterest] [decimal] (18, 2) NULL,
[ReductionUnservicedInterestDuetoRecovery_Arcs] [decimal] (18, 2) NULL,
[FinalAssetClassAlt_Key] [int] NULL,
[FinalUnservicedInterest] [decimal] (18, 2) NULL,
[TotalAddition_UnservicedInterest] [decimal] (18, 2) NULL,
[TotalReduction_UnservicedInterest] [decimal] (18, 2) NULL,
[MovementStatus] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UnservicedInterestReason] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Movement_Flag] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
