CREATE TABLE [dbo].[BuyoutSummary_Stg]
(
[Entity_Key] [int] NOT NULL IDENTITY(1, 1),
[AUNo] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PoolName] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Category] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TotalNoofBuyoutParty] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TotalPrincipalOutstandinginRs] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TotalInterestReceivableinRs] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BuyoutOSBalanceinRs] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TotalChargesinRs] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TotalAccuredInterestinRs] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UploadID] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SummaryID] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
