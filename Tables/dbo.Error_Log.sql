CREATE TABLE [dbo].[Error_Log]
(
[Entitykey] [int] NOT NULL IDENTITY(1, 1),
[ErrorLine] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ErrorMessage] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ErrorNumber] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ErrorProcedure] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ErrorSeverity] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ErrorState] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ErrorDateTime] [datetime] NULL
) ON [PRIMARY]
GO
