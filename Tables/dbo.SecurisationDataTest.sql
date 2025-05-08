CREATE TABLE [dbo].[SecurisationDataTest]
(
[Pool ID] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Pool Name] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Securitisation Type] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Account ID] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Customer ID] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Principal Outstanding in Rs#] [float] NULL,
[Interest Receivable in Rs#] [float] NULL,
[O/S Balance in Rs#] [float] NULL,
[Securitisation Exposure in Rs#] [float] NULL,
[Date of Securitisation reckoning] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Date of Securitisation marking] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Maturity Date] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
