CREATE TABLE [dbo].[StatusReport]
(
[SourceAlt_Key] [int] NULL,
[SourceName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Upgrade_ACL] [int] NULL,
[Upgrade_RF] [int] NULL,
[Upgrade_Status] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Degrade_ACL] [int] NULL,
[Degrade_RF] [int] NULL,
[Degrade_Status] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
