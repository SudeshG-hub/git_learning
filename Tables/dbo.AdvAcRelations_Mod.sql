CREATE TABLE [dbo].[AdvAcRelations_Mod]
(
[EntityKey] [int] NOT NULL IDENTITY(1, 1),
[BranchCode] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RelationEntityId] [int] NULL,
[CustomerEntityId] [int] NOT NULL,
[AccountEntityId] [int] NOT NULL,
[RelationTypeAlt_Key] [smallint] NULL,
[RelationSrNo] [smallint] NULL,
[RelationshipAuthorityCodeAlt_Key] [smallint] NULL,
[InwardNo] [int] NULL,
[FacilityNo] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[GuaranteeValue] [decimal] (16, 2) NULL,
[RefCustomerID] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RefSystemAcId] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AuthorisationStatus] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EffectiveFromTimeKey] [int] NULL,
[EffectiveToTimeKey] [int] NULL,
[CreatedBy] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateCreated] [smalldatetime] NULL,
[ModifiedBy] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateModified] [smalldatetime] NULL,
[ApprovedBy] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateApproved] [smalldatetime] NULL,
[D2Ktimestamp] [timestamp] NOT NULL,
[StatusActionTaken] [varchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
