CREATE TABLE [CurDat].[AdvFacPCDetail]
(
[EntityKey] [bigint] NOT NULL,
[AccountEntityId] [int] NOT NULL,
[PCRefNo] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[PCAdvDt] [date] NULL,
[PCAmt] [decimal] (16, 2) NULL,
[PCDueDt] [date] NULL,
[PCDurationDays] [smallint] NULL,
[PCExtendedDueDt] [date] NULL,
[ExtensionReason] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CurrencyAlt_Key] [smallint] NULL,
[LcNo] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LcAmt] [decimal] (14, 0) NULL,
[LcIssueDt] [date] NULL,
[LcIssuingBank_FirmOrder] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Balance] [decimal] (16, 2) NULL,
[BalanceInCurrency] [decimal] (16, 4) NULL,
[BalanceInUSD] [decimal] (16, 4) NULL,
[Overdue] [decimal] (14, 0) NULL,
[CommodityAlt_Key] [smallint] NULL,
[CommodityValue] [decimal] (14, 0) NULL,
[CommodityMarketValue] [decimal] (14, 0) NULL,
[ShipmentDt] [date] NULL,
[CommercialisationDt] [date] NULL,
[EcgcPolicyNo] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CAD] [decimal] (14, 0) NULL,
[CADU] [decimal] (14, 0) NULL,
[OverDueSinceDt] [date] NULL,
[TotalProv] [decimal] (14, 0) NULL,
[Secured] [decimal] (14, 0) NULL,
[Unsecured] [decimal] (14, 0) NULL,
[Provsecured] [decimal] (14, 0) NULL,
[ProvUnsecured] [decimal] (14, 0) NULL,
[ProvDicgc] [decimal] (14, 0) NULL,
[npadt] [date] NULL,
[CoverGovGur] [decimal] (16, 2) NULL,
[DerecognisedInterest1] [decimal] (14, 0) NULL,
[DerecognisedInterest2] [decimal] (14, 0) NULL,
[ClaimType] [varchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ClaimCoverAmt] [decimal] (14, 0) NULL,
[ClaimLodgedDt] [date] NULL,
[ClaimLodgedAmt] [decimal] (14, 0) NULL,
[ClaimRecvDt] [date] NULL,
[ClaimReceivedAmt] [decimal] (14, 0) NULL,
[ClaimRate] [decimal] (4, 2) NULL,
[AdjDt] [date] NULL,
[EntityClosureDate] [date] NULL,
[EntityClosureReasonAlt_Key] [smallint] NULL,
[RefSystemAcid] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AuthorisationStatus] [char] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EffectiveFromTimeKey] [int] NOT NULL,
[EffectiveToTimeKey] [int] NOT NULL,
[CreatedBy] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateCreated] [smalldatetime] NULL,
[ModifiedBy] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateModified] [smalldatetime] NULL,
[ApprovedBy] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateApproved] [smalldatetime] NULL,
[D2Ktimestamp] [datetime] NULL,
[UnAppliedIntt] [decimal] (14, 2) NULL,
[MocTypeAlt_Key] [smallint] NULL,
[MocStatus] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MocDate] [smalldatetime] NULL,
[RBI_ExtnPermRefNo] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LC_OrderAlt_Key] [smallint] NULL,
[OrderLC_CurrencyAlt_Key] [smallint] NULL,
[CountryAlt_Key] [smallint] NULL,
[LcAmtInCurrenc] [decimal] (16, 4) NULL
) ON [PRIMARY]
GO
ALTER TABLE [CurDat].[AdvFacPCDetail] ADD CONSTRAINT [CK__AdvFacPCD__Effec__49B9D516] CHECK (([EffectiveToTimeKey]=(49999)))
GO
ALTER TABLE [CurDat].[AdvFacPCDetail] ADD CONSTRAINT [CK__AdvFacPCD__Effec__4AADF94F] CHECK (([EffectiveToTimeKey]=(49999)))
GO
ALTER TABLE [CurDat].[AdvFacPCDetail] ADD CONSTRAINT [AdvFacPCDetail_AccountEntityID] PRIMARY KEY NONCLUSTERED ([AccountEntityId], [PCRefNo], [EffectiveFromTimeKey], [EffectiveToTimeKey]) ON [PRIMARY]
GO
