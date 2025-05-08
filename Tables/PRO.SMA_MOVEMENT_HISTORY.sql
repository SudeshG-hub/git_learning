CREATE TABLE [PRO].[SMA_MOVEMENT_HISTORY]
(
[TIMEKEY] [int] NULL,
[CustomerAcID] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PrevStatus] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CurrentStatus] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PrevStatusDt] [date] NULL
) ON [PRIMARY]
GO
