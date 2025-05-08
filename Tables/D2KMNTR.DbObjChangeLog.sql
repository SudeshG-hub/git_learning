CREATE TABLE [D2KMNTR].[DbObjChangeLog]
(
[LogID] [int] NOT NULL IDENTITY(1, 1),
[DatabaseName] [varchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SchemaName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DbType] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EventType] [varchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ObjectName] [varchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ObjectType] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ChangeDescription] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SqlCommand] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LoginName] [varchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[HostName] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TSql] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PostTime] [datetime] NULL,
[ServerName] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SPID] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
