CREATE TABLE [dbo].[ExcelTemplateDirectory]
(
[EntityKey] [int] NOT NULL IDENTITY(1, 1),
[ExcelId] [int] NULL,
[ExcelName] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ExcelFilePath] [varchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[StateAlt_Key] [int] NULL,
[EffectiveFromTimeKey] [int] NULL,
[EffectiveToTimeKey] [int] NULL,
[CreatedBy] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateCreated] [smalldatetime] NULL,
[ModifyBy] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateModified] [smalldatetime] NULL,
[ExcelSheetName] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FrequencyAlt_Key] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ReportAmountIn] [int] NULL,
[NumberUnit] [int] NULL,
[Scope] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BankReportNo] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ReturnShortName] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ReportDay] [int] NULL,
[ReportSource] [int] NULL,
[Uploads] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
