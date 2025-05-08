CREATE TABLE [dbo].[SysUserActivityLog]
(
[EntityKey] [int] NOT NULL,
[BranchCode] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[MenuID] [int] NOT NULL,
[ReferenceID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LogCreationStatus] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LogCreatedBy] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LogCreatedDt] [date] NULL,
[LogStatus] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LogCheckedBy] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LogCheckedDt] [date] NULL,
[Remark] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ScreenEntityAlt_Key] [int] NULL
) ON [PRIMARY]
GO
