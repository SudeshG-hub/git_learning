CREATE TABLE [dbo].[final]
(
[CIF ID] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TypeOfRestructure] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[System] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Restructure date] [datetime] NULL,
[CurrentNPA_Date] [datetime] NULL,
[D2K upgrade file] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Name] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UCIC] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Rest Stage] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SP_Expiry date] [datetime] NULL
) ON [PRIMARY]
GO
