CREATE TABLE [CurDat].[ADVACCAL]
(
[ENTITYKEY] [bigint] NOT NULL IDENTITY(1, 1),
[AccountEntityID] [int] NULL,
[CustomerEntityID] [int] NULL,
[CustomerAcID] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RefSystemACID] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RefCustomerID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BranchCode] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SecurityValue] [decimal] (16, 2) NULL,
[DFVAmt] [decimal] (16, 2) NULL,
[OthAdjRec] [decimal] (16, 2) NULL,
[GovtGtyAmt] [decimal] (16, 2) NULL,
[CoverGovGur] [decimal] (16, 2) NULL,
[UnAdjSubSidy] [decimal] (16, 2) NULL,
[MarginAmt] [decimal] (16, 2) NULL,
[NetBalance] [decimal] (16, 2) NULL,
[ApprRV] [decimal] (18, 2) NULL,
[SecuredAmt] [decimal] (16, 2) NULL,
[UnSecuredAmt] [decimal] (16, 2) NULL,
[ProvDFV] [decimal] (16, 2) NULL,
[Provsecured] [decimal] (16, 2) NULL,
[ProvUnsecured] [decimal] (16, 2) NULL,
[ProvCoverGovGur] [decimal] (16, 2) NULL,
[TotalProvision] [decimal] (16, 2) NULL,
[AddlProvision] [decimal] (16, 2) NULL,
[SMA_Dt] [date] NULL,
[UpgDate] [date] NULL,
[DegReason] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Asset_Norm] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ExposureAmt] [decimal] (16, 2) NULL,
[PNPA_Reason] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ProvisionAlt_Key] [int] NULL,
[PrvAssetClassAlt_Key] [int] NULL,
[RefPeriodOverdue] [smallint] NULL,
[RefPeriodOverDrawn] [smallint] NULL,
[RefPeriodNoCredit] [smallint] NULL,
[RefPeriodIntService] [smallint] NULL,
[RefPeriodStkStatement] [smallint] NULL,
[RefPeriodReview] [smallint] NULL,
[SMA_Class] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SMA_Reason] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SourceAlt_Key] [tinyint] NULL,
[FlgDeg] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FlgDirtyRow] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FlgInMonth] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FlgSMA] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FlgPNPA] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FlgUpg] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[REFPeriodMax] [int] NULL,
[FinalNpaDt] [date] NULL,
[FlgFITL] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FlgAbinitio] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FinalAssetClassAlt_Key] [int] NULL,
[NPA_Days] [int] NULL,
[RefPeriodOverdueUPG] [smallint] NULL,
[RefPeriodOverDrawnUPG] [smallint] NULL,
[RefPeriodNoCreditUPG] [smallint] NULL,
[RefPeriodIntServiceUPG] [smallint] NULL,
[RefPeriodStkStatementUPG] [smallint] NULL,
[RefPeriodReviewUPG] [smallint] NULL,
[CommonMocTypeAlt_Key] [smallint] NULL,
[EffectiveFromTimeKey] [int] NULL,
[EffectiveToTimeKey] [int] NULL,
[FlgMoc] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MOC_Dt] [date] NULL
) ON [PRIMARY]
GO
