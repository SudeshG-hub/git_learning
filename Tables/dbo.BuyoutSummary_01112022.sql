CREATE TABLE [dbo].[BuyoutSummary_01112022]
(
[Entity_Key] [int] NOT NULL IDENTITY(1, 1),
[AUNo] [varchar] (16) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PoolName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Category] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TotalNoofBuyoutParty] [int] NULL,
[TotalPrincipalOutstandinginRs] [decimal] (18, 2) NULL,
[TotalInterestReceivableinRs] [decimal] (18, 2) NULL,
[BuyoutOSBalanceinRs] [decimal] (18, 2) NULL,
[TotalChargesinRs] [decimal] (18, 2) NULL,
[TotalAccuredInterestinRs] [decimal] (18, 2) NULL,
[AuthorisationStatus] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EffectiveFromTimeKey] [int] NULL,
[EffectiveToTimeKey] [int] NULL,
[CreatedBy] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateCreated] [datetime] NULL,
[ModifyBy] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateModified] [date] NULL,
[ApprovedBy] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateApproved] [date] NULL,
[SummaryID] [int] NULL,
[NoOfAccount] [int] NULL
) ON [PRIMARY]
GO
