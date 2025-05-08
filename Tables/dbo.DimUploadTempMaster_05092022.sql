CREATE TABLE [dbo].[DimUploadTempMaster_05092022]
(
[EntityKey] [int] NOT NULL IDENTITY(1, 1),
[MenuId] [int] NULL,
[UploadType] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ColumnName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SheetName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Department] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DataType] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
