CREATE TABLE [CurDat].[AdvAcRelations]
(
[EntityKey] [bigint] NOT NULL,
[BranchCode] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RelationEntityId] [int] NOT NULL,
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
[EffectiveFromTimeKey] [int] NOT NULL,
[EffectiveToTimeKey] [int] NOT NULL,
[CreatedBy] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateCreated] [smalldatetime] NULL,
[ModifiedBy] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateModified] [smalldatetime] NULL,
[ApprovedBy] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateApproved] [smalldatetime] NULL,
[D2Ktimestamp] [datetime] NOT NULL,
[StatusActionTaken] [varchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [CurDat].[AdvAcRelations] ADD CONSTRAINT [CK__AdvAcRela__Effec__3B6BB5BF] CHECK (([EffectiveToTimeKey]=(49999)))
GO
ALTER TABLE [CurDat].[AdvAcRelations] ADD CONSTRAINT [CK__AdvAcRela__Effec__3C5FD9F8] CHECK (([EffectiveToTimeKey]=(49999)))
GO
ALTER TABLE [CurDat].[AdvAcRelations] ADD CONSTRAINT [AdvAcRelations_RelationEntityId] PRIMARY KEY NONCLUSTERED ([CustomerEntityId], [AccountEntityId], [RelationEntityId], [EffectiveFromTimeKey], [EffectiveToTimeKey]) ON [PRIMARY]
GO
