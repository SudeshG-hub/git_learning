CREATE TABLE [dbo].[DIMPROVISION_SEG]
(
[EntityKey] [int] NOT NULL IDENTITY(1, 1),
[Provision_Key] [smallint] NULL,
[ProvisionAlt_Key] [smallint] NULL,
[Segment] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ProvisionRule] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SecurityApplicable] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ProductAlt_Key] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ProvisionName] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ProvisionShortNameEnum] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ProvisionSecured] [decimal] (5, 2) NULL,
[ProvisionUnSecured] [decimal] (5, 2) NULL,
[LowerDPD] [int] NULL,
[UpperDPD] [int] NULL,
[AuthorisationStatus] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EffectiveFromTimeKey] [int] NOT NULL,
[EffectiveToTimeKey] [int] NOT NULL,
[CreatedBy] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateCreated] [smalldatetime] NULL,
[ModifiedBy] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateModified] [smalldatetime] NULL,
[ApprovedBy] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateApproved] [smalldatetime] NULL,
[DB1_PROV] [decimal] (18, 2) NULL,
[DB2_PROV] [decimal] (18, 2) NULL,
[ProvProductCat] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RBIProvisionSecured] [decimal] (10, 4) NULL,
[RBIProvisionUnSecured] [decimal] (10, 4) NULL,
[EffectiveFromDate] [int] NULL,
[AdditionalprovisionRBINORMS] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Period_as_NPA] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Revised_accelerated_Provision_SECURED] [decimal] (16, 2) NULL,
[Revised_accelerated_Provision_UNSECURED] [decimal] (16, 2) NULL
) ON [PRIMARY]
GO
