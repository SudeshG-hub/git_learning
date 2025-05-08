CREATE TABLE [dbo].[CutomerLevelMOC_Mod]
(
[Entity_Key] [int] NOT NULL IDENTITY(1, 1),
[CustomerID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomerEntityID] [int] NULL,
[AssetClass] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NPADate] [date] NULL,
[SecurityValue] [decimal] (18, 2) NULL,
[AdditionalProvision] [decimal] (16, 2) NULL,
[FraudAccountFlag] [varchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FraudDate] [date] NULL,
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
