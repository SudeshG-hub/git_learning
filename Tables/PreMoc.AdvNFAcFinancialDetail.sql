CREATE TABLE [PreMoc].[AdvNFAcFinancialDetail]
(
[EntityKey] [int] NOT NULL IDENTITY(1, 1),
[CustomerEntityId] [int] NOT NULL,
[AccountEntityId] [int] NOT NULL,
[Ac_ReviewTypeAlt_key] [smallint] NULL,
[Ac_ReviewAuthAlt_Key] [smallint] NULL,
[BalanceInCurrency] [decimal] (16, 4) NULL,
[Balance] [decimal] (16, 2) NULL,
[SignBalance] [decimal] (16, 2) NULL,
[OverDue] [decimal] (14, 0) NULL,
[UnDrawnAmt] [decimal] (10, 0) NULL,
[ProvSecured] [decimal] (14, 0) NULL,
[ProvUnSecured] [decimal] (14, 0) NULL,
[AdditionalProv] [decimal] (14, 0) NULL,
[TotalProv] [decimal] (14, 0) NULL,
[SecTangAst] [decimal] (14, 0) NULL,
[CoverGovGur] [decimal] (14, 0) NULL,
[Unsecured] [decimal] (14, 0) NULL,
[RefCustomerId] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RefSystemAcId] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AuthorisationStatus] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EffectiveFromTimeKey] [int] NOT NULL,
[EffectiveToTimeKey] [int] NOT NULL,
[CreatedBy] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateCreated] [smalldatetime] NULL,
[ModifiedBy] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateModified] [smalldatetime] NULL,
[ApprovedBy] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateApproved] [smalldatetime] NULL,
[D2Ktimestamp] [timestamp] NOT NULL,
[MocDate] [smalldatetime] NULL,
[MocStatus] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MocTypeAlt_Key] [int] NULL,
[Ac_ReviewAuthLevelAlt_Key] [smallint] NULL
) ON [PRIMARY]
GO
ALTER TABLE [PreMoc].[AdvNFAcFinancialDetail] ADD CONSTRAINT [AdvNfAcFinancialDetail_PK] PRIMARY KEY NONCLUSTERED ([EffectiveFromTimeKey], [EffectiveToTimeKey], [AccountEntityId]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
