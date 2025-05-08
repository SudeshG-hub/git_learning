CREATE TABLE [CurDat].[InvestmentBasicDetail]
(
[EntityKey] [bigint] NOT NULL,
[BranchCode] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[InvEntityId] [int] NOT NULL,
[InvID] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IssuerEntityId] [int] NOT NULL,
[RefIssuerID] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ISIN] [varchar] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[InstrTypeAlt_Key] [tinyint] NULL,
[InstrName] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[InvestmentNature] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[InternalRating] [tinyint] NULL,
[InRatingDate] [date] NULL,
[InRatingExpiryDate] [date] NULL,
[ExRating] [tinyint] NULL,
[ExRatingAgency] [tinyint] NULL,
[ExRatingDate] [date] NULL,
[ExRatingExpiryDate] [date] NULL,
[Sector] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Industry_AltKey] [tinyint] NULL,
[ListedStkExchange] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ExposureType] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SecurityValue] [decimal] (18, 2) NULL,
[MaturityDt] [date] NULL,
[ReStructureDate] [date] NULL,
[MortgageStatus] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NHBStatus] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ResiPurpose] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AuthorisationStatus] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EffectiveFromTimeKey] [int] NOT NULL,
[EffectiveToTimeKey] [int] NOT NULL,
[CreatedBy] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateCreated] [smalldatetime] NULL,
[ModifiedBy] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateModified] [smalldatetime] NULL,
[ApprovedBy] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateApproved] [smalldatetime] NULL
) ON [PRIMARY]
GO
ALTER TABLE [CurDat].[InvestmentBasicDetail] ADD CONSTRAINT [CK__Investmen__Effec__4E7E8A33] CHECK (([EffectiveToTimeKey]=(49999)))
GO
ALTER TABLE [CurDat].[InvestmentBasicDetail] ADD CONSTRAINT [InvestmentBasicDetail_InvEntityId] PRIMARY KEY NONCLUSTERED ([InvEntityId], [EffectiveFromTimeKey], [EffectiveToTimeKey]) ON [PRIMARY]
GO
CREATE CLUSTERED INDEX [InvestmentBasicDetail_ClsIdx] ON [CurDat].[InvestmentBasicDetail] ([EntityKey]) ON [PRIMARY]
GO
