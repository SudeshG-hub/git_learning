CREATE TABLE [dbo].[UserDetail_stg]
(
[Entity_Key] [int] NOT NULL IDENTITY(1, 1),
[SrNo] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UserID] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UserName] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UserRole] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Designation] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UserDepartment] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UserEmailId] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UserMobileNumber] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UserExtensionNumber] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IsChecker] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IsChecker2] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IsActive] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[sheetname] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ActionAU] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
