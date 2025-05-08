CREATE TABLE [dbo].[MetaDynamicMasterFilter]
(
[EntityKey] [smallint] NOT NULL IDENTITY(1, 1),
[MasterFilterGrpKey] [smallint] NOT NULL,
[MasterFilterKey] [smallint] NOT NULL,
[ControlID] [int] NOT NULL,
[FilterMasterControlName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[RefColumnName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FilterByColumnName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FilterBySelectValue] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FilterByRemoveValue] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MenuID] [smallint] NULL,
[ExpectedValue] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
