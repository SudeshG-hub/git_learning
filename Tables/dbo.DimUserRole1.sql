CREATE TABLE [dbo].[DimUserRole1]
(
[UserRole_Key] [smallint] NOT NULL,
[UserRoleAlt_Key] [smallint] NULL,
[RoleDescription] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateCreated] [smalldatetime] NULL,
[CreatedBy] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateModified] [smalldatetime] NULL,
[ApprovedBy] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EffectiveFromTimeKey] [int] NULL,
[EffectiveToTimeKey] [int] NULL,
[RecordStatus] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UserRoleShortName] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UserRoleShortNameEnum] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UserRoleGroup] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UserRoleSubGroup] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UserRoleSegment] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UserRoleValidCode] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SrcSysUserRoleCode] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SrcSysUserRoleName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DestSystemUserRoleCode] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
