CREATE TABLE [dbo].[BANDAUDITSTATUS]
(
[EntityKey] [bigint] NOT NULL IDENTITY(1, 1),
[BandName] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[StartDate] [date] NULL,
[BandStatus] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TotalCount] [bigint] NULL,
[CompletedCount] [bigint] NULL
) ON [PRIMARY]
GO
