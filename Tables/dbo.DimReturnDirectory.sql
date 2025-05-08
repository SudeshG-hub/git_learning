CREATE TABLE [dbo].[DimReturnDirectory]
(
[entityKey] [int] NOT NULL IDENTITY(1, 1),
[returnId] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[returnName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[createdModifyBy] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[createDate] [datetime] NULL,
[ReturnAlt_Key] [int] NULL,
[ReportGenType] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
