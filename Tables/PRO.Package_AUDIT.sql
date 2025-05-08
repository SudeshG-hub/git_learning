CREATE TABLE [PRO].[Package_AUDIT]
(
[IdentityKey] [int] NOT NULL,
[UserID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Execution_date] [date] NULL,
[PackageName] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[TableName] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ExecutionStartTime] [smalldatetime] NULL,
[ExecutionEndTime] [smalldatetime] NULL,
[TimeDuration_Min] [int] NULL,
[ExecutionStatus] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ProcessingDate] [date] NULL
) ON [PRIMARY]
GO
