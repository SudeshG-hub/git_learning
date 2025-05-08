CREATE TABLE [dbo].[WilfulPartyAccountDetail_Mod]
(
[Entity_Key] [int] NOT NULL IDENTITY(1, 1),
[CustomerID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PartyName] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PAN] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AccountID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SourceSystem] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FacilityTypeAlt_Key] [int] NULL,
[OSBalanceInRsLac] [numeric] (18, 2) NULL,
[BranchCode] [int] NULL,
[BranchName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EffectiveFromTimeKey] [int] NULL,
[EffectiveToTimeKey] [int] NULL,
[AuthorisationStatus] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreatedBy] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateCreated] [date] NULL,
[ModifiedBy] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateModified] [date] NULL,
[ApprovedBy] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateApproved] [date] NULL
) ON [PRIMARY]
GO
