CREATE TABLE [dbo].[ReverseFeedDataCount]
(
[ProcessDate] [date] NULL,
[GenerationDate] [datetime] NOT NULL,
[Name] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SourceName] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Count] [int] NULL
) ON [PRIMARY]
GO
