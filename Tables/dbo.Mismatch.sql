CREATE TABLE [dbo].[Mismatch]
(
[UCIC] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CIF ID] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[D2K NPA Date] [datetime] NULL,
[MOC Date of NPA] [datetime] NULL,
[Diff] [bit] NOT NULL,
[Remarks] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Source System] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomerEntityid] [int] NULL
) ON [PRIMARY]
GO
