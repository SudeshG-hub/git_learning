CREATE TABLE [dbo].[BuyoutDetails_Mod]
(
[Entity_Key] [int] NOT NULL IDENTITY(1, 1),
[SlNo] [int] NULL,
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
[DateCreated] [date] NULL,
[ModifyBy] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateModified] [date] NULL,
[ApprovedBy] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateApproved] [date] NULL,
[UploadID] [int] NULL,
[SummaryID] [int] NULL,
[ApprovedByFirstLevel] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateApprovedFirstLevel] [date] NULL,
[Action] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ChangeFields] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
