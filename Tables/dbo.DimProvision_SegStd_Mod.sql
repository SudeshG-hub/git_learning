CREATE TABLE [dbo].[DimProvision_SegStd_Mod]
(
[EntityKey] [int] NOT NULL IDENTITY(1, 1),
[Provision_Key] [smallint] NULL,
[ProvisionAlt_Key] [smallint] NULL,
[Segment] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ProvisionRule] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SecurityApplicable] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ProductAlt_Key] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BankCategoryID] [int] NULL,
[ProvisionName] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CategoryTypeAlt_Key] [int] NULL,
[ProvisionShortNameEnum] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ProvisionSecured] [decimal] (10, 4) NULL,
[ProvisionUnSecured] [decimal] (10, 4) NULL,
[LowerDPD] [int] NULL,
[UpperDPD] [int] NULL,
[AuthorisationStatus] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EffectiveFromTimeKey] [int] NULL,
[EffectiveToTimeKey] [int] NULL,
[EffectiveFromDate] [int] NULL,
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
[AdditionalBanksProvision] [decimal] (18, 2) NULL,
[AdditionalprovisionRBINORMS] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Changes] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Remark] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BusinessRuleAlt_Key] [int] NULL,
[Expression] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SystemFinalExpression] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UserFinalExpression] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ChangeFields] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
