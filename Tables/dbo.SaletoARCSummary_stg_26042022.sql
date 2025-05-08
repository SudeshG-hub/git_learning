CREATE TABLE [dbo].[SaletoARCSummary_stg_26042022]
(
[Entity_Key] [int] NOT NULL IDENTITY(1, 1),
[UploadID] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SummaryID] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NoofAccounts] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TotalPOSinRs] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TotalInttReceivableinRs] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TotaloutstandingBalanceinRs] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ExposuretoARCinRs] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateOfSaletoARC] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateOfApproval] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
