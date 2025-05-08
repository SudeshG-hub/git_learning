CREATE TABLE [dbo].[dimdepartment]
(
[Department_Key] [int] NOT NULL IDENTITY(1, 1),
[DepartmentAlt_Key] [int] NULL,
[DepartmentCode] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DepartmentName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DepartmentShortName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DepartmentShortNameEnum] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DepartmentGroup] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DepartmentSubGroup] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DepartmentSegment] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ApplicableBACID] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ContactPersonUserID] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AuthorisationStatus] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EffectiveFromTimeKey] [int] NULL,
[EffectiveToTimeKey] [int] NULL,
[CreatedBy] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateCreated] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ModifiedBy] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateModified] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ApprovedBy] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateApproved] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[D2Ktimestamp] [timestamp] NOT NULL,
[ChangeFields] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
