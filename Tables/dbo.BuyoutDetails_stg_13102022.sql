CREATE TABLE [dbo].[BuyoutDetails_stg_13102022]
(
[Entity_Key] [int] NOT NULL IDENTITY(1, 1),
[SlNo] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AUNo] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PoolName] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Category] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BuyoutPartyLoanNo] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomerName] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PAN] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AadharNo] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PrincipalOutstanding] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[InterestReceivable] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Charges] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AccuredInterest] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DPD] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AssetClass] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Action] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[filname] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SummaryID] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
