CREATE TABLE [dbo].[DimTypeServiceSummon]
(
[ServiceSummon_Key] [smallint] NOT NULL IDENTITY(1, 1),
[ServiceSummonAlt_Key] [smallint] NOT NULL,
[ServiceSummonName] [nvarchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ServiceSummonShortName] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ServiceSummonShortNameEnum] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ServiceSummonGroup] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ServiceSummonGroupOrderKey] [tinyint] NULL,
[ServiceSummonSubGroup] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ServiceSummonSubGroupOrderKey] [tinyint] NULL,
[ServiceSummonSegment] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ServiceSummonValidCode] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SrcSysClassnName] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SrcSysClassCode] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AuthorisationStatus] [char] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EffectiveFromTimeKey] [int] NULL,
[EffectiveToTimeKey] [int] NULL,
[DateCreated] [smalldatetime] NULL,
[CreatedBy] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateModified] [smalldatetime] NULL,
[ModifyBy] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateApproved] [smalldatetime] NULL,
[ApprovedBy] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[D2Ktimestamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
