CREATE TABLE [dbo].[DimBusinessGroup]
(
[BusinessGroup_Key] [smallint] NOT NULL,
[BusinessGroupAlt_Key] [smallint] NULL,
[BusinessGroupName] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BusinessGroupShortName] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BusinessGroupShortNameEnum] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BusinessGroupGroup] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BusinessGroupSubGroup] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BusinessGroupSegment] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BusinessGroupValidCode] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SrcSysBusinessGroupCode] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SrcSysBusinessGroupName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DestSysBusinessGroupCode] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AuthorisationStatus] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EffectiveFromTimeKey] [int] NULL,
[EffectiveToTimeKey] [int] NULL,
[CreatedBy] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateCreated] [smalldatetime] NULL,
[ModifiedBy] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateModifie] [smalldatetime] NULL,
[ApprovedBy] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateApproved] [smalldatetime] NULL,
[D2Ktimestamp] [timestamp] NOT NULL,
[RbiGroupCode] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RbiGroupDesc] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
