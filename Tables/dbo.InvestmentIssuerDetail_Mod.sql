CREATE TABLE [dbo].[InvestmentIssuerDetail_Mod]
(
[EntityKey] [bigint] NOT NULL IDENTITY(1, 1),
[BranchCode] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IssuerEntityId] [int] NOT NULL,
[IssuerID] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IssuerName] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IssuerAccpRating] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IssuerAccpRatingDt] [date] NULL,
[IssuerRatingAgency] [tinyint] NULL,
[Ref_Txn_Sys_Cust_ID] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Issuer_Category_Code] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[GrpEntityOfBank] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
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
[InvestmentIssuerDetail_ChangeFields] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
