CREATE TABLE [dbo].[MetaCerDescription]
(
[EntityKey] [int] NOT NULL IDENTITY(1, 1),
[ScreenName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ClientName] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ScreenFieldNo] [smallint] NULL,
[ScrCrErrorSeq] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ScreenFldName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ColumnName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CerDescription] [varchar] (4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EffectiveFromTimeKey] [int] NULL,
[EffectiveToTimeKey] [int] NULL,
[ValidCode] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[XmlTableName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
