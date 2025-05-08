CREATE TABLE [dbo].[DIMNFNATURE]
(
[NfNature_Key] [smallint] NOT NULL,
[NfNatureAlt_Key] [smallint] NOT NULL,
[NfNatureName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NfNatureShortName] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NfNatureShortNameEnum] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NfNatureGroup] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NfNatureSubGroup] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NfNatureSegment] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NfNatureValidCode] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ConvFactor] [smallint] NULL,
[SrcSysNfNatureCode] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SrcSysNfNatureName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DestSysNfNatureCode] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AuthorisationStatus] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EffectiveFromTimeKey] [int] NOT NULL,
[EffectiveToTimeKey] [int] NOT NULL,
[CreatedBy] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateCreated] [smalldatetime] NULL,
[ModifiedBy] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateModifie] [smalldatetime] NULL,
[ApprovedBy] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateApproved] [smalldatetime] NULL,
[D2Ktimestamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
