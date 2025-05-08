CREATE TABLE [dbo].[DimDepttoBacid]
(
[EntityKey] [int] NOT NULL IDENTITY(1, 1),
[BACID] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DepartmentAlt_Key] [int] NULL
) ON [PRIMARY]
GO
