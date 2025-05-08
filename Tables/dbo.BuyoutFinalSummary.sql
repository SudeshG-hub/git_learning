CREATE TABLE [dbo].[BuyoutFinalSummary]
(
[Entity_Key] [int] NOT NULL IDENTITY(1, 1),
[CIFId] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ENBDAcNo] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BuyoutPartyLoanNo] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PartnerDPD] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PartnerDPDAsOnDate] [datetime] NULL,
[PartnerAssetClass] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PartnerNPADate] [datetime] NULL,
[AuthorisationStatus] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Changes] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Remark] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
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
