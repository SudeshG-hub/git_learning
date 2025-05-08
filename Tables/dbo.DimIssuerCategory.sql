CREATE TABLE [dbo].[DimIssuerCategory]
(
[IssuerCategory_Key] [smallint] NOT NULL,
[IssuerCategoryAlt_Key] [smallint] NULL,
[IssuerCategoryName] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IssuerCategoryShortName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IssuerCategoryShortNameEnum] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IssuerCategoryGroup] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IssuerCategorySubGroup] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AuthorisationStatus] [char] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EffectiveFromTimeKey] [int] NULL,
[EffectiveToTimeKey] [int] NULL,
[CreatedBy] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateCreated] [smalldatetime] NULL,
[ModifiedBy] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateModifie] [smalldatetime] NULL,
[ApprovedBy] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateApproved] [smalldatetime] NULL,
[D2Ktimestamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
