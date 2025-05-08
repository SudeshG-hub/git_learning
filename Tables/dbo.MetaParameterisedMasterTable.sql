CREATE TABLE [dbo].[MetaParameterisedMasterTable]
(
[EntityKey] [int] NOT NULL IDENTITY(1, 1),
[TableName] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[XMLTableName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ColumnSelect] [varchar] (2000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[InnerJoin] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[WhereCondition] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[GroupBy] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OrderBy] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreatedBy] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateCreated] [smalldatetime] NULL,
[ModifiedBy] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateModifie] [smalldatetime] NULL,
[ApprovedBy] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateApproved] [smalldatetime] NULL
) ON [PRIMARY]
GO
