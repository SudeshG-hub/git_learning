CREATE TABLE [dbo].[UploadBuyout]
(
[Entity_Key] [int] NOT NULL IDENTITY(1, 1),
[SlNo] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CIFID] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ENBDACNo] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BuyoutPartyLoanNo] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PartnerDPD] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PartnerDPDasonDate] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PartnerAssetClass] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PartnerNPADate] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[filname] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SummaryID] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ErrorMessage] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ErrorinColumn] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Srnooferroneousrows] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
