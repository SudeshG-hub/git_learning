CREATE TABLE [PRO].[ReverseFeed_ProcessMonitor]
(
[IdentityKey] [int] NOT NULL IDENTITY(1, 1),
[UserID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Description] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Mode] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[StartTime] [datetime] NULL,
[EndTime] [datetime] NULL,
[TimeTaken_Sec] AS (datediff(second,[StartTime],[EndTime])) PERSISTED,
[TimeKey] [int] NULL,
[SetID] [int] NULL,
[Proc_Loc] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[StatusFlag] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [PRO].[ReverseFeed_ProcessMonitor] ADD CONSTRAINT [PK__ReverseF__796424B8D94AE5A6] PRIMARY KEY CLUSTERED ([IdentityKey]) ON [PRIMARY]
GO
