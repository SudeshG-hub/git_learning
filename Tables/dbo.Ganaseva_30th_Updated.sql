CREATE TABLE [dbo].[Ganaseva_30th_Updated]
(
[Customer_Ac_ID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Principal_Overdue_Amt] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[principal_Over_due_Since_dt] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Interest_Overdue_Amt] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Interest_Over_Due_Since_Dt] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Oth_Charges_Over_Due_Since_Dt] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Oth_Charges_Overdue_Amt] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[principal_Over_due_Since_dt_NEW] [date] NULL,
[Interest_Over_Due_Since_Dt_NEW] [date] NULL,
[Oth_Charges_Over_Due_Since_Dt_NEW] [date] NULL,
[OVERDUE_SINCE_DATE] [date] NULL
) ON [PRIMARY]
GO
