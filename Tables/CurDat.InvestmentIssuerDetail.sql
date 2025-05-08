CREATE TABLE [CurDat].[InvestmentIssuerDetail]
(
[EntityKey] [bigint] NOT NULL,
[BranchCode] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IssuerEntityId] [int] NOT NULL,
[IssuerID] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IssuerName] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RatingStatus] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IssuerAccpRating] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IssuerAccpRatingDt] [date] NULL,
[IssuerRatingAgency] [tinyint] NULL,
[Ref_Txn_Sys_Cust_ID] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Issuer_Category_Code] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[GrpEntityOfBank] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AuthorisationStatus] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EffectiveFromTimeKey] [int] NOT NULL,
[EffectiveToTimeKey] [int] NOT NULL,
[CreatedBy] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateCreated] [smalldatetime] NULL,
[ModifiedBy] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateModified] [smalldatetime] NULL,
[ApprovedBy] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateApproved] [smalldatetime] NULL,
[SourceAlt_key] [int] NULL,
[UcifId] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PanNo] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FlgSMA] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SMA_Dt] [date] NULL,
[SMA_Class] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BranchAlt_Key] [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [CurDat].[InvestmentIssuerDetail] ADD CONSTRAINT [CK__Investmen__Effec__5066D2A5] CHECK (([EffectiveToTimeKey]=(49999)))
GO
ALTER TABLE [CurDat].[InvestmentIssuerDetail] ADD CONSTRAINT [CK__Investmen__Effec__67AC8CB5] CHECK (([EffectiveToTimeKey]=(49999)))
GO
ALTER TABLE [CurDat].[InvestmentIssuerDetail] ADD CONSTRAINT [InvestmentIssuerDetail_IssuerEntityId] PRIMARY KEY NONCLUSTERED ([IssuerEntityId], [EffectiveFromTimeKey], [EffectiveToTimeKey]) ON [PRIMARY]
GO
CREATE CLUSTERED INDEX [InvestmentIssuerDetail_ClsIdx] ON [CurDat].[InvestmentIssuerDetail] ([EntityKey]) ON [PRIMARY]
GO
