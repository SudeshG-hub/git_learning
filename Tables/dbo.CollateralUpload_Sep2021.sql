CREATE TABLE [dbo].[CollateralUpload_Sep2021]
(
[Sr# No#] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Old Collateral ID] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Tagging Level] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Related UCIC / Customer ID / Account ID] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Distribution Level] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Distribution Value] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Collateral Type] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Collateral Sub-Type] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Collateral Owner Type] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Collateral Ownership Type] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Charge Type] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Charge Nature] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Share available to Bank] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Share value] [float] NULL,
[Collateral Value at Sanction in Rs#] [float] NULL,
[Collateral Value as on NPA Date  in Rs#] [float] NULL,
[Collateral Value at Last Review in Rs#] [float] NULL,
[Valuation Date] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Current Collateral Value in Rs#] [float] NULL,
[Expiry Business Rule] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Valuation Expiry date] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FileName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ENtityKey] [int] NOT NULL IDENTITY(1, 1),
[SecurityEntityID] [int] NULL
) ON [PRIMARY]
GO
