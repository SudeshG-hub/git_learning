CREATE TABLE [dbo].[Manual_NPA_BKP]
(
[Customer ID] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Customer Name] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Account No] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NPA (Manual/Automatic)] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Reason] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Source system] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DATE_OF_DATA] [date] NULL,
[VALID_UPTO] [date] NULL,
[NPA_dATE] [date] NULL
) ON [PRIMARY]
GO
