CREATE TABLE [dbo].[WebAPILog]
(
[D2KTimeStamp] [timestamp] NULL,
[ResponseType] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IP] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Device] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[API] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Response] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Status] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Port] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Url] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ServerName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Param] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Token] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
