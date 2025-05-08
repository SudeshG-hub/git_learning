CREATE TABLE [dbo].[UserLoginHistory]
(
[EntityKey] [int] NOT NULL IDENTITY(1, 1),
[UserID] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IP_Address] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LoginTime] [datetime] NULL,
[LogoutTime] [datetime] NULL,
[DurationMin] [smallint] NULL,
[LoginSucceeded] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BranchCode] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
