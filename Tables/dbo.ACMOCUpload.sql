CREATE TABLE [dbo].[ACMOCUpload]
(
[Sl# No#] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Account ID] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[POS in Rs#] [float] NULL,
[Interest Receivable in Rs#] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Additional Provision - Absolute in Rs#] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Restructure Flag(Y/N)] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Restructure Date] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FITL Flag (Y/N)] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DFV Amount] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Fraud Flag] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Fraud Date] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MOC Source] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MOC Reason] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Source System] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
