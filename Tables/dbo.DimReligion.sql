CREATE TABLE [dbo].[DimReligion]
(
[Religion_Key] [smallint] NOT NULL,
[ReligionAlt_Key] [smallint] NULL,
[ReligionOrderKey] [tinyint] NULL,
[ReligionName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ReligionShortName] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ReligionShortNameEnum] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ReligionGroup] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ReligionSubGroup] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ReligionSegment] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ReligionValidCode] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SrcSysReligionCode] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SrcSysReligionName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DestSysReligionCode] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AuthorisationStatus] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EffectiveFromTimeKey] [int] NULL,
[EffectiveToTimeKey] [int] NULL,
[CreatedBy] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateCreated] [smalldatetime] NULL,
[ModifyBy] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateModified] [smalldatetime] NULL,
[ApprovedBy] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateApproved] [smalldatetime] NULL,
[D2Ktimestamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
