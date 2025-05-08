CREATE TABLE [dbo].[Employee]
(
[EmpID] [int] NOT NULL IDENTITY(1, 1),
[Ename] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Age] [int] NULL
) ON [PRIMARY]
GO
