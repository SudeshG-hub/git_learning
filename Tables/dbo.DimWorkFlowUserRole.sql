CREATE TABLE [dbo].[DimWorkFlowUserRole]
(
[WorkFlowUserRole_Key] [smallint] NOT NULL,
[WorkFlowUserRoleAlt_Key] [smallint] NULL,
[WorkFlowUserRoleName] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[WorkFlowUserRoleShortName] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[WorkFlowUserRoleShortNameEnum] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[WorkFlowUserRoleGroup] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[WorkFlowUserRoleSubGroup] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[WorkFlowUserRoleSegment] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[WorkFlowUserRoleValidCode] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SrcSysWorkFlowUserRoleCode] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SrcSysWorkFlowUserRoleName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DestSysWorkFlowUserRoleCode] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
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
