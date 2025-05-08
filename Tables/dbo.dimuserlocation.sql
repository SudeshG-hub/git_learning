CREATE TABLE [dbo].[dimuserlocation]
(
[UserLocation_Key] [smallint] NOT NULL,
[UserLocationAlt_Key] [smallint] NULL,
[LocationName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LocationShortName] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LocationShortNameEnum] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UserLocationGroup] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UserLocationSubGroup] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UserLocationSegment] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UserLocationValidCode] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SrcSysUserLocationCode] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SrcSysUserLocationName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DestSysUserLocationCode] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
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
