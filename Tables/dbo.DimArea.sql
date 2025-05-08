CREATE TABLE [dbo].[DimArea]
(
[Area_Key] [smallint] NOT NULL,
[AreaAlt_Key] [smallint] NULL,
[AreaName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[AreaNameOrderKey] [tinyint] NULL,
[AreaShortName] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AreaShortNameEnum] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AreaGroup] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AreaSubGroup] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AreaSegment] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AreaValidCode] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SrcSysAreaCode] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SrcSysAreaName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DestSysAreaCode] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AuthorisationStatus] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
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
