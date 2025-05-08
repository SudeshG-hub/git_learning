CREATE TABLE [dbo].[Automate_Advances_08092021]
(
[Id] [int] NOT NULL,
[Timekey] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Date] [datetime] NULL,
[EffectiveFromTimekey] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DataEffectiveFromDate] [datetime] NULL,
[EffectiveToTimekey] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DataEffectiveToDate] [datetime] NULL,
[MonthEndDate] [datetime] NULL,
[MonthStartDate] [datetime] NULL,
[EXT_FLG] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FridayYN] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
