CREATE TABLE [PreMoc].[AdvSecurityInsuranceDetail]
(
[EntityKey] [int] NOT NULL IDENTITY(1, 1),
[SecurityEntityID] [int] NULL,
[Insurance_RefNo] [varchar] (40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[InsuranceTypeAlt_Key] [smallint] NULL,
[InsurancePolicyNo] [varchar] (40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[InsuranceCompany] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[InsuranceDt] [date] NULL,
[InsuranceAmt] [decimal] (14, 0) NULL,
[InsuranceExpiryDt] [date] NULL,
[AuthorisationStatus] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EffectiveFromTimeKey] [int] NULL,
[EffectiveToTimeKey] [int] NULL,
[CreatedBy] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateCreated] [smalldatetime] NULL,
[ModifiedBy] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateModified] [smalldatetime] NULL,
[ApprovedBy] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateApproved] [smalldatetime] NULL,
[D2Ktimestamp] [timestamp] NOT NULL,
[MocTypeAlt_Key] [int] NULL
) ON [PRIMARY]
GO
