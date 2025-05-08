CREATE TABLE [dbo].[AdvAcOtherBalanceDetail_Mod]
(
[EntityKey] [int] NOT NULL IDENTITY(1, 1),
[CustomerEntityId] [int] NULL,
[AccountEntityID] [int] NULL,
[Principal] [decimal] (16, 2) NULL,
[PartialWO] [decimal] (16, 2) NULL,
[UnapplInt] [decimal] (16, 2) NULL,
[BookInt] [decimal] (16, 2) NULL,
[Expenses] [decimal] (16, 2) NULL,
[Other] [decimal] (16, 2) NULL,
[Total] [decimal] (18, 2) NULL,
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
