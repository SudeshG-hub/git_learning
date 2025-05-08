CREATE TABLE [PRO].[PROCESSMONITOR_MOC]
(
[IdentityKey] [int] NOT NULL IDENTITY(1, 1),
[UserID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Description] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Mode] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[StartTime] [datetime] NULL,
[EndTime] [datetime] NULL,
[TimeTaken_Sec] [int] NULL,
[TimeKey] [int] NULL,
[SetID] [int] NULL,
[Proc_Loc] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[StatusFlag] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CurrentTimeKey] [int] NULL
) ON [PRIMARY]
GO
