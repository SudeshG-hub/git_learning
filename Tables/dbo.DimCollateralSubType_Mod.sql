CREATE TABLE [dbo].[DimCollateralSubType_Mod]
(
[EntityKey] [int] NOT NULL IDENTITY(1, 1),
[CollateralSubTypeAltKey] [int] NULL,
[CollateralTypeAltKey] [int] NULL,
[CollateralSubTypeID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CollateralSubType] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CollateralSubTypeDescription] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
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
[DateApproved] [smalldatetime] NULL,
[Valid] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SrcSecurityCode] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SourceAlt_Key] [int] NULL
) ON [PRIMARY]
GO
