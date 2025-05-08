CREATE TABLE [dbo].[DimCollateralChargeType_Mod]
(
[EntityKey] [int] NOT NULL IDENTITY(1, 1),
[CollateralChargeTypeAltKey] [int] NULL,
[ChargeTypeID] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ChargeType] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CollChargeDescription] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EffectiveFromTimeKey] [int] NULL,
[EffectiveToTimeKey] [int] NULL,
[ChangeFields] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Remarks] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AuthorisationStatus] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreatedBy] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateCreated] [smalldatetime] NULL,
[ModifiedBy] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateModified] [smalldatetime] NULL,
[ApprovedBy] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateApproved] [smalldatetime] NULL
) ON [PRIMARY]
GO
