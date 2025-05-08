CREATE TABLE [dbo].[MOCMonitorStatus]
(
[EntityKey] [int] NOT NULL IDENTITY(1, 1),
[UserID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MocMainSP] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MocStatus] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MocSubSP] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MocStatusSub] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TimeKey] [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[MOCMonitorStatus] ADD CONSTRAINT [PK__MOCMonit__9EC07B8E75B6AEA9] PRIMARY KEY CLUSTERED ([EntityKey]) ON [PRIMARY]
GO
