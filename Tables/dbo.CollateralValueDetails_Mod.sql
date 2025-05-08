CREATE TABLE [dbo].[CollateralValueDetails_Mod]
(
[Entity_Key] [int] NOT NULL IDENTITY(1, 1),
[CollateralID] [int] NULL,
[CollateralValueatSanctioninRs] [decimal] (18, 2) NULL,
[CollateralValueasonNPAdateinRs] [decimal] (18, 2) NULL,
[CollateralValueatthetimeoflastreviewinRs] [decimal] (18, 2) NULL,
[ValuationSourceNameAlt_Key] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ValuationDate] [datetime] NULL,
[LatestCollateralValueinRs] [decimal] (18, 2) NULL,
[ExpiryBusinessRule] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Periodinmonth] [int] NULL,
[ValueExpirationDate] [datetime] NULL,
[EffectiveFromTimeKey] [int] NULL,
[EffectiveToTimeKey] [int] NULL,
[AuthorisationStatus] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Changes] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Remark] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreatedBy] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateCreated] [datetime] NULL,
[ModifiedBy] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateModified] [datetime] NULL,
[ApprovedBy] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateApproved] [datetime] NULL
) ON [PRIMARY]
GO
