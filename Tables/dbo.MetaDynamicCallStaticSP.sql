CREATE TABLE [dbo].[MetaDynamicCallStaticSP]
(
[Entitykey] [smallint] NOT NULL IDENTITY(1, 1),
[ControlID] [int] NULL,
[SPName] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ClientSideParams] [varchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ServerSideParams] [varchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
