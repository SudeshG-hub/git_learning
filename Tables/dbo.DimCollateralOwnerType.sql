CREATE TABLE [dbo].[DimCollateralOwnerType]
(
[EntityKey] [int] NOT NULL IDENTITY(1, 1),
[CollateralOwnerTypeAltKey] [int] NULL,
[OwnerID] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OwnerShipType] [char] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CollOwnerDescription] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EffectiveFromTimeKey] [int] NULL,
[EffectiveToTimeKey] [int] NULL,
[AuthorisationStatus] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreatedBy] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateCreated] [smalldatetime] NULL,
[ModifiedBy] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateModified] [smalldatetime] NULL,
[ApprovedBy] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateApproved] [smalldatetime] NULL
) ON [PRIMARY]
GO
