CREATE TABLE [dbo].[ProjectCategorySubType]
(
[EntityKey] [int] NOT NULL IDENTITY(1, 1),
[ProjectCategorySubTypeAltKey] [int] NULL,
[ProjectCategoryTypeAltKey] [int] NULL,
[ProjectCategorySubTypeID] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ProjectCategorySubType] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ProjectCategorySubTypeDescription] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EffectiveFromTimeKey] [int] NULL,
[EffectiveToTimeKey] [int] NULL,
[AuthorisationStatus] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreatedBy] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateCreated] [smalldatetime] NULL,
[ModifiedBy] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateModified] [smalldatetime] NULL,
[ApprovedBy] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateApproved] [smalldatetime] NULL
) ON [PRIMARY]
GO
