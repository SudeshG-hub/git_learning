CREATE TABLE [dbo].[NPA_reason]
(
[Sl# No#] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Customer ID] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Asset Class] [float] NULL,
[NPA Date] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Security Value] [datetime] NULL,
[Additional Provision %] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MOC Source] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MOC Type] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MOC Reason] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Source System] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
