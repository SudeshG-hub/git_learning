CREATE TABLE [dbo].[UserPwdChangeHistory]
(
[EntityKey] [smallint] NOT NULL IDENTITY(1, 1),
[SeqNo] [smallint] NULL,
[UserLoginID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LoginPassword] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PwdChangeTime] [date] NULL,
[DateCreated] [smalldatetime] NULL,
[CreatedBy] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Status] [bit] NULL
) ON [PRIMARY]
GO
