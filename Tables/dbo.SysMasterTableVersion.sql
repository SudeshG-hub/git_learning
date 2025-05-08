CREATE TABLE [dbo].[SysMasterTableVersion]
(
[TableVersionAlt_Key] [smallint] NOT NULL IDENTITY(1, 1),
[TableName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[VersionNo] [int] NULL,
[LastModifiedDate] [date] NULL
) ON [PRIMARY]
GO
