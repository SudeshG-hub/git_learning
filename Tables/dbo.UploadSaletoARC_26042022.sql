CREATE TABLE [dbo].[UploadSaletoARC_26042022]
(
[EntityKey] [int] NOT NULL IDENTITY(1, 1),
[SrNo] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UploadID] [int] NULL,
[AccountID] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomerID] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PrincipalOutstandinginRs] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[InterestReceivableinRs] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BalanceOSinRs] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ExposuretoARCinRs] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateOfSaletoARC] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateOfApproval] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[filname] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ErrorMessage] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ErrorinColumn] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Srnooferroneousrows] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
