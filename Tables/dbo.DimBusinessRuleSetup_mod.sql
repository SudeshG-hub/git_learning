CREATE TABLE [dbo].[DimBusinessRuleSetup_mod]
(
[Entitykey] [int] NOT NULL IDENTITY(1, 1),
[BusinessRule_Alt_key] [int] NULL,
[CatAlt_key] [int] NULL,
[UniqueID] [int] NULL,
[Businesscolalt_key] [int] NULL,
[Scope] [int] NULL,
[Businesscolvalues1] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Businesscolvalues] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ChangeFields] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Remarks] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AuthorisationStatus] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EffectiveFromTimeKey] [int] NULL,
[EffectiveToTimeKey] [int] NULL,
[CreatedBy] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateCreated] [datetime] NULL,
[ModifiedBy] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateModified] [datetime] NULL,
[ApprovedBy] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateApproved] [datetime] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[DimBusinessRuleSetup_mod] ADD CONSTRAINT [PK__DimBusin__96C3FDA029685EBA] PRIMARY KEY CLUSTERED ([Entitykey]) ON [PRIMARY]
GO
