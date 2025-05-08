CREATE TABLE [dbo].[UploadStatus]
(
[EntityKey] [int] NOT NULL IDENTITY(1, 1),
[FileNames] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UploadedBy] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UploadDateTime] [datetime] NULL,
[UploadType] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ValidationOfSheetNames] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ValidationOfSheetCompletedOn] [datetime] NULL,
[ValidationOfData] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ValidationOfDataCompletedOn] [datetime] NULL,
[InsertionOfData] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[InsertionCompletedOn] [datetime] NULL,
[TruncateTable] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TruncateTableCompletedOn] [datetime] NULL
) ON [PRIMARY]
GO
