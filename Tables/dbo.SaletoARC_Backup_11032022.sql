CREATE TABLE [dbo].[SaletoARC_Backup_11032022]
(
[EntityKey] [int] NOT NULL IDENTITY(1, 1),
[SourceSystem] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomerID] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomerName] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AccountID] [varchar] (16) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BalanceOutstanding] [decimal] (18, 2) NULL,
[POS] [decimal] (18, 2) NULL,
[InterestReceivable] [decimal] (18, 2) NULL,
[DtofsaletoARC] [date] NULL,
[DateofApproval] [date] NULL,
[AmountSold] [decimal] (18, 2) NULL,
[AuthorisationStatus] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EffectiveFromTimeKey] [int] NULL,
[EffectiveToTimeKey] [int] NULL,
[CreatedBy] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateCreated] [datetime] NULL,
[ModifyBy] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateModified] [date] NULL,
[ApprovedBy] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateApproved] [datetime] NULL,
[D2Ktimestamp] [timestamp] NOT NULL,
[ChangeFields] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PoolID] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PoolName] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
