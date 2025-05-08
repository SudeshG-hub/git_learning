CREATE TABLE [dbo].[DimSecurityChargeTypeMapping]
(
[EntityKey] [int] NOT NULL IDENTITY(1, 1),
[SecurityMappingAlt_Key] [int] NULL,
[SecurityChargeTypeAlt_Key] [int] NULL,
[SecurityChargeTypeCode] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SecurityChargeTypeName] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SecurityChargeTypeShortName] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SecurityChargeTypeShortNameEnum] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SecurityChargeTypeGroup] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SecurityChargeTypeSubGroup] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SecurityChargeTypeSegment] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SecurityChargeTypeValidCode] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SrcSysSecurityChargeTypeCode] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SrcSysSecurityChargeTypeName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DestSysSecurityChargeTypeCode] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AuthorisationStatus] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EffectiveFromTimeKey] [int] NULL,
[EffectiveToTimeKey] [int] NULL,
[CreatedBy] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateCreated] [datetime] NULL,
[ModifiedBy] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateModifie] [datetime] NULL,
[ApprovedBy] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateApproved] [datetime] NULL,
[D2Ktimestamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
