CREATE TABLE [dbo].[DimUserDeletionReason]
(
[UserDeletionReason_Key] [smallint] NOT NULL,
[UserDeletionReasonAlt_Key] [smallint] NOT NULL,
[UserDeletionReasonName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[UserDeletionReasonShortName] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UserDeletionReasonShortNameEnum] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UserDeletionReasonGroup] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UserDeletionReasonSubGroup] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UserDeletionReasonSegment] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UserDeletionReasonValidCode] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SrcSysUserDeletionReasonCode] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SrcSysUserDeletionReasonName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DestSysUserDeletionReasonCode] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
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
