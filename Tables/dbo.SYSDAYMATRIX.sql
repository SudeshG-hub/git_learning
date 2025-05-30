CREATE TABLE [dbo].[SYSDAYMATRIX]
(
[TimeKey] [int] NOT NULL,
[Date] [datetime] NOT NULL,
[DateName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[WeekDateKey] [int] NULL,
[WeekDate] [datetime] NULL,
[WeekName] [nvarchar] (18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LastWkDateKey] [int] NULL,
[LastWkDate] [datetime] NULL,
[LastQtrDateKey] [int] NULL,
[LastQtrDate] [datetime] NULL,
[LastToLastQtrDateKey] [int] NULL,
[LastToLastQtrDate] [datetime] NULL,
[ParallelWkLastYearKey] [int] NULL,
[ParallelWkLastYear] [datetime] NULL,
[ParallelWkLastToLastYearKey] [int] NULL,
[ParallelWkLastToLastYear] [datetime] NULL,
[LastFinYearKey] [int] NULL,
[LastFinYear] [datetime] NULL,
[LastToLastFinYearKey] [int] NULL,
[LastToLastFinYear] [datetime] NULL,
[LastToLastToLastFinYearKey] [int] NULL,
[LastToLastToLastFinYear] [datetime] NULL,
[LastToLastToLastQtrKey] [int] NULL,
[LastToLastToLastQtr] [datetime] NULL,
[IsCurrentDay] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IsSuccess] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CurFinYearKey] [int] NULL,
[CurFinYear] [date] NULL,
[CurQtrDateKey] [int] NULL,
[CurQtrDate] [date] NULL,
[FinYearQ1_EndDate] [datetime] NULL,
[FinYearQ1_EndDateKey] [int] NULL,
[FinYearQ2_EndDate] [datetime] NULL,
[FinYearQ2_EndDateKey] [int] NULL,
[FinYearQ3_EndDate] [datetime] NULL,
[FinYearQ3_EndDateKey] [int] NULL,
[FinYearQ4_EndDate] [datetime] NULL,
[FinYearQ4_EndDateKey] [int] NULL,
[LastMonthDate] [datetime] NULL,
[LastMonthDateKey] [int] NULL,
[PrevMonthFirstDate] [date] NULL,
[PrevMonthFirstDateKey] [int] NULL,
[LastToLastFortnight] [date] NULL,
[LastFortnight] [date] NULL,
[CurFortnight] [date] NULL,
[LastToLastMonthDate] [datetime] NULL,
[CurrentMonthDate] [datetime] NULL,
[HalfYrDateKey] [int] NULL,
[HalfYrDate] [date] NULL,
[PrevHalfYrDateKey] [int] NULL,
[PrevHalfYrDate] [date] NULL,
[Spl_friday] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ReportingFriday] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CurrentMonthDateKey] [int] NULL
) ON [PRIMARY]
GO
