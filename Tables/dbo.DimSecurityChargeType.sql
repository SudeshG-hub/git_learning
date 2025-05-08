CREATE TABLE [dbo].[DimSecurityChargeType]
(
[SecurityChargeType_Key] [smallint] NOT NULL,
[SecurityChargeTypeAlt_Key] [smallint] NULL,
[SecurityChargeTypeCode] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SecurityChargeTypeName] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SecurityChargeTypeShortName] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SecurityChargeTypeShortNameEnum] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SecurityChargeTypeGroup] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SecurityChargeTypeSubGroup] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SecurityChargeTypeSegment] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SecurityChargeTypeValidCode] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SrcSysSecurityChargeTypeCode] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SrcSysSecurityChargeTypeName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DestSysSecurityChargeTypeCode] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AuthorisationStatus] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EffectiveFromTimeKey] [int] NULL,
[EffectiveToTimeKey] [int] NULL,
[CreatedBy] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateCreated] [smalldatetime] NULL,
[ModifiedBy] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateModifie] [smalldatetime] NULL,
[ApprovedBy] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateApproved] [smalldatetime] NULL,
[D2Ktimestamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
