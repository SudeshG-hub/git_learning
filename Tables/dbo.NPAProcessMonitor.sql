CREATE TABLE [dbo].[NPAProcessMonitor]
(
[IdentityKey] [int] NOT NULL IDENTITY(1, 1),
[UserID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Description] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Mode] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[StartTime] [datetime] NULL,
[EndTime] [datetime] NULL,
[TimeTaken_Min] [int] NULL,
[TimeKey] [smallint] NULL,
[SetID] [int] NULL,
[Proc_Loc] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
