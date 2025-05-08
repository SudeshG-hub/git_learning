CREATE TABLE [dbo].[ReverseFeed_ENPA_Header]
(
[ATHEZ-H-ORG] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ATHEZ-H-CLIENT-ID] [varchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ATHEZ-H-DATE] [varchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ATHEZ-H-BULK-UPD-ONLINE] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FILLER] [varchar] (180) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateofData] [date] NULL,
[EffectiveFromTimeKey] [int] NULL,
[EffectiveToTimeKey] [int] NULL
) ON [PRIMARY]
GO
