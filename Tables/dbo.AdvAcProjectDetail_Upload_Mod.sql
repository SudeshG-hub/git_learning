CREATE TABLE [dbo].[AdvAcProjectDetail_Upload_Mod]
(
[EntityKey] [int] NOT NULL IDENTITY(1, 1),
[CustomerEntityID] [int] NULL,
[CustomerID] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomerName] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AccountID] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OriginalEnvisagCompletionDt] [datetime] NULL,
[RevisedCompletionDt] [datetime] NULL,
[ActualCompletionDt] [datetime] NULL,
[ProjectCat] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ProjectDelReason] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[StandardRestruct] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
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
