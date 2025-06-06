CREATE TABLE [dbo].[DimDayMatrix]
(
[TimeKey] [smallint] NOT NULL,
[Date] [datetime] NOT NULL,
[DateName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[WeekDateKey] [smallint] NULL,
[WeekDate] [datetime] NULL,
[WeekName] [nvarchar] (18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LastWkDateKey] [smallint] NULL,
[LastWkDate] [datetime] NULL,
[LastQtrDateKey] [smallint] NULL,
[LastQtrDate] [datetime] NULL,
[LastToLastQtrDateKey] [smallint] NULL,
[LastToLastQtrDate] [datetime] NULL,
[ParallelWkLastYearKey] [smallint] NULL,
[ParallelWkLastYear] [datetime] NULL,
[ParallelWkLastToLastYearKey] [smallint] NULL,
[ParallelWkLastToLastYear] [datetime] NULL,
[LastFinYearKey] [smallint] NULL,
[LastFinYear] [datetime] NULL,
[LastToLastFinYearKey] [smallint] NULL,
[LastToLastFinYear] [datetime] NULL,
[LastToLastToLastFinYearKey] [smallint] NULL,
[LastToLastToLastFinYear] [datetime] NULL,
[LastToLastToLastQtrKey] [smallint] NULL,
[LastToLastToLastQtr] [datetime] NULL,
[IsCurrentDay] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IsSuccess] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
