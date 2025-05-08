CREATE TABLE [PRO].[AclRunningProcessStatus]
(
[id] [int] NULL,
[RunningProcessName] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Completed] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ErrorDescription] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ErrorDate] [date] NULL,
[count] [int] NULL
) ON [PRIMARY]
GO
