CREATE TABLE [dbo].[security_1]
(
[EntityKey] [bigint] NOT NULL IDENTITY(1, 1),
[BranchCode] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UCIF_ID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UcifEntityID] [int] NULL,
[CustomerEntityID] [int] NULL,
[ParentCustomerID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RefCustomerID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SourceSystemCustomerID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomerName] [varchar] (225) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustSegmentCode] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ConstitutionAlt_Key] [int] NULL,
[PANNO] [varchar] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AadharCardNO] [varchar] (14) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SrcAssetClassAlt_Key] [smallint] NULL,
[SysAssetClassAlt_Key] [smallint] NULL,
[SplCatg1Alt_Key] [int] NULL,
[SplCatg2Alt_Key] [int] NULL,
[SplCatg3Alt_Key] [int] NULL,
[SplCatg4Alt_Key] [int] NULL,
[SMA_Class_Key] [int] NULL,
[PNPA_Class_Key] [int] NULL,
[PrvQtrRV] [decimal] (18, 2) NULL,
[CurntQtrRv] [decimal] (18, 2) NULL,
[TotProvision] [decimal] (16, 2) NULL,
[RBITotProvision] [decimal] (18, 2) NULL,
[BankTotProvision] [decimal] (16, 2) NULL,
[SrcNPA_Dt] [date] NULL,
[SysNPA_Dt] [date] NULL,
[DbtDt] [date] NULL,
[DbtDt2] [date] NULL,
[DbtDt3] [date] NULL,
[LossDt] [date] NULL,
[MOC_Dt] [date] NULL,
[ErosionDt] [date] NULL,
[SMA_Dt] [date] NULL,
[PNPA_Dt] [date] NULL,
[Asset_Norm] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FlgDeg] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FlgUpg] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FlgMoc] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FlgSMA] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FlgProcessing] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FlgErosion] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FlgPNPA] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FlgPercolation] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FlgInMonth] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FlgDirtyRow] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DegDate] [date] NULL,
[EffectiveFromTimeKey] [int] NULL,
[EffectiveToTimeKey] [int] NULL,
[CommonMocTypeAlt_Key] [smallint] NULL,
[InMonthMark] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MocStatusMark] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SourceAlt_Key] [int] NULL,
[BankAssetClass] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Cust_Expo] [decimal] (18, 2) NULL,
[MOCReason] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AddlProvisionPer] [decimal] (6, 2) NULL,
[FraudDt] [date] NULL,
[FraudAmount] [decimal] (18, 2) NULL,
[DegReason] [varchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustMoveDescription] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TotOsCust] [decimal] (18, 2) NULL,
[MOCTYPE] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IsChanged] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EntityKeyNew] [bigint] NULL
) ON [PRIMARY]
GO
