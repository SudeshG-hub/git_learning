CREATE TABLE [dbo].[MetaExpertNavigationWizard]
(
[SrNo] [int] NOT NULL IDENTITY(1, 1),
[Category] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Category_Type] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Criteria] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MasterSelect] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MasterSelectValue] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MasterData] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SubCriteria] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SubMasterSelect] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SubMasterSelectValue] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SubMasterData] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SelectRange] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ReportId] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
