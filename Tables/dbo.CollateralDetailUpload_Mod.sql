CREATE TABLE [dbo].[CollateralDetailUpload_Mod]
(
[SrNo] [int] NULL,
[AccountID] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CollateralType] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CollateralSubType] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ChargeType] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ChargeNature] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ValuationDate] [date] NULL,
[CurrCollateralValue] [decimal] (16, 2) NULL,
[ValSource_ExpBusinessRule] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UploadID] [int] NULL,
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
[DateApproved] [datetime] NULL,
[CollateralID] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
