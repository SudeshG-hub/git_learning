CREATE TABLE [dbo].[ErrorMessageVOS]
(
[ErrorMsg] [varchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Flag] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TableName] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FileNames] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
