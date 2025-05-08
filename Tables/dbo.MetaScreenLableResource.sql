CREATE TABLE [dbo].[MetaScreenLableResource]
(
[EntityKey] [int] NOT NULL IDENTITY(1, 1),
[ControlName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Lable] [nvarchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LanguageKey] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MenuID] [int] NULL,
[ControlID] [int] NULL
) ON [PRIMARY]
GO
