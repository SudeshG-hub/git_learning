CREATE TABLE [dbo].[BuyoutUploadDetails_stg]
(
[EntityKey] [int] NOT NULL IDENTITY(1, 1),
[SlNo] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AccountNo] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SchemeCode] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NPAClassificationwithSeller] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateofNPAwithSeller] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DPDwithSeller] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PeakDPDwithSeller] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PeakDPDDate] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ReportDate] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[filname] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateofData] [date] NULL
) ON [PRIMARY]
GO
