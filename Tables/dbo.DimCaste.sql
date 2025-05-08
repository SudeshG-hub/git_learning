CREATE TABLE [dbo].[DimCaste]
(
[Caste_Key] [smallint] NOT NULL,
[CasteAlt_Key] [smallint] NULL,
[CasteOrderKey] [tinyint] NULL,
[CasteName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CasteShortName] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CasteShortNameEnum] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CasteGroup] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CasteSubGroup] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CasteSegment] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CasteValidCode] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SrcSysCasteCode] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SrcSysCasteName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DestSysCasteCode] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
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
