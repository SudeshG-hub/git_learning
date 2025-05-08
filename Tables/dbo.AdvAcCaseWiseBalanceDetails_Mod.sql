CREATE TABLE [dbo].[AdvAcCaseWiseBalanceDetails_Mod]
(
[EntityKey] [int] NOT NULL IDENTITY(1, 1),
[CustomerEntityId] [int] NULL,
[AccountEntityID] [int] NULL,
[ClaimPrincipal] [decimal] (16, 2) NULL,
[ClaimPartialWO] [decimal] (16, 2) NULL,
[ClaimUnapplInt] [decimal] (16, 2) NULL,
[ClaimBookInt] [decimal] (16, 2) NULL,
[ClaimExpenses] [decimal] (16, 2) NULL,
[ClaimOther] [decimal] (16, 2) NULL,
[ClaimTotal] [decimal] (16, 2) NULL,
[AuthorisationStatus] [char] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EffectiveFromTimeKey] [int] NULL,
[EffectiveToTimeKey] [int] NULL,
[CreatedBy] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateCreated] [smalldatetime] NULL,
[ModifiedBy] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateModified] [smalldatetime] NULL,
[ApprovedBy] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateApproved] [smalldatetime] NULL,
[D2Ktimestamp] [timestamp] NOT NULL,
[ChangeFields] [varchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
