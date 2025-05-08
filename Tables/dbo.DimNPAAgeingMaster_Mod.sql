CREATE TABLE [dbo].[DimNPAAgeingMaster_Mod]
(
[EntityKey] [int] NOT NULL IDENTITY(1, 1),
[NPAAlt_Key] [int] NULL,
[BusinessRule] [varchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RefValue] [varchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AuthorisationStatus] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Changes] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Remark] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EffectiveFromTimeKey] [int] NULL,
[EffectiveToTimeKey] [int] NULL,
[CreatedBy] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateCreated] [datetime] NULL,
[ApprovedBy] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateApproved] [datetime] NULL,
[ModifiedBy] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateModified] [datetime] NULL,
[Changefields] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
