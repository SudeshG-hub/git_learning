CREATE TABLE [dbo].[Dimuserinfo_18062022]
(
[EntityKey] [int] NOT NULL IDENTITY(1, 1),
[UserLoginID] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UserName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LoginPassword] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PasswordChanged] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PasswordChangeDate] [date] NULL,
[ChangePwdCnt] [smallint] NULL,
[UserLocation] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UserLocationCode] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UserRoleAlt_Key] [smallint] NULL,
[SuspendedUser] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CurrentLoginDate] [date] NULL,
[ResetDate] [date] NULL,
[Activate] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UserLogged] [bit] NULL,
[UserDeletionReasonAlt_Key] [int] NULL,
[SystemLogOut] [bit] NULL,
[EmployeeID] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UserType] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IsEmployee] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IsChecker] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RBIFLAG] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DeptGroupCode] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Email_ID] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SecuritQsnAlt_Key] [int] NULL,
[SecurityAns] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MenuId] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AuthorisationStatus] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EffectiveFromTimeKey] [int] NULL,
[EffectiveToTimeKey] [int] NULL,
[CreatedBy] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateCreated] [smalldatetime] NULL,
[ModifyBy] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateModified] [smalldatetime] NULL,
[ApprovedBy] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateApproved] [smalldatetime] NULL,
[D2Ktimestamp] [timestamp] NOT NULL,
[MIS_APP_USR_ID] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MIS_APP_USR_PASS] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UserLocationExcel] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DesignationAlt_Key] [smallint] NULL,
[MobileNo] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IsCMA] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SSOUse] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SessionId] [int] NULL,
[ProffEntityId] [int] NULL,
[GradeScaleAlt_Key] [smallint] NULL,
[EmployeeTypeAlt_Key] [smallint] NULL,
[IsReport] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UserActivationDate] [date] NULL,
[UserDeactivationDate] [date] NULL,
[WorkFlowUserRoleAlt_Key] [smallint] NULL,
[DepartmentId] [int] NULL,
[ApplicableSolIds] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ApplicableBACID] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ScreenFlag] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IsChecker2] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Extension] [int] NULL,
[Designation] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SailPoint] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ChangeFields] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
