CREATE TABLE [dbo].[DimUserDeptGroup_10032022]
(
[EntityKey] [smallint] NOT NULL IDENTITY(1, 1),
[DeptGroupId] [smallint] NULL,
[DeptGroupCode] [varchar] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DeptGroupName] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Menus] [varchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IsUniversal] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AuthorisationStatus] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EffectiveFromTimeKey] [int] NULL,
[EffectiveToTimeKey] [int] NULL,
[CreatedBy] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateCreated] [smalldatetime] NULL,
[ModifiedBy] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateModified] [smalldatetime] NULL,
[ApprovedBy] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateApproved] [smalldatetime] NULL,
[D2Ktimestamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
