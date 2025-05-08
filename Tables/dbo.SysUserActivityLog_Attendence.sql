CREATE TABLE [dbo].[SysUserActivityLog_Attendence]
(
[EntityKey] [int] NOT NULL IDENTITY(1, 1),
[BranchCode] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[MenuID] [int] NOT NULL,
[ReferenceID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LogCreationStatus] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LogCreatedBy] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LogCreatedDt] [datetime] NULL,
[LogStatus] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LogCheckedBy] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LogCheckedDt] [datetime] NULL,
[Remark] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ScreenEntityAlt_Key] [int] NULL,
[ScreenType] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EditCount] [int] NULL,
[DeleteCount] [int] NULL,
[AuthoriseCount] [int] NULL,
[RejectCount] [int] NULL
) ON [PRIMARY]
GO
