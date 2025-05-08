CREATE TABLE [dbo].[BANDAUDITSTATUS_backup]
(
[EntityKey] [int] NOT NULL IDENTITY(1, 1),
[BandName] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[StartDate] [date] NULL,
[BandStatus] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TotalCount] [int] NULL,
[CompletedCount] [int] NULL
) ON [PRIMARY]
GO
