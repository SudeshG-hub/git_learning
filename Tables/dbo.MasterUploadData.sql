CREATE TABLE [dbo].[MasterUploadData]
(
[SR_No] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ColumnName] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ErrorData] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ErrorType] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FileNames] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Flag] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Srnooferroneousrows] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
