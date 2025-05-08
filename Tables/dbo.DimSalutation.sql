CREATE TABLE [dbo].[DimSalutation]
(
[Salutation_Key] [smallint] NOT NULL,
[SalutationAlt_Key] [smallint] NULL,
[SalutationName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SalutationShortName] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SalutationShortNameEnum] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SalutationGroup] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SalutationSubGroup] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SalutationSegment] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SalutationValidCode] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SrcSysSalutationCode] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SrcSysSalutationName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DestSysSalutationCode] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AuthorisationStatus] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
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
