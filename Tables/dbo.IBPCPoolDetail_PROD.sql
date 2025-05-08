CREATE TABLE [dbo].[IBPCPoolDetail_PROD]
(
[SummaryID] [int] NULL,
[PoolID] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PoolName] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomerID] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AccountID] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
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
[EntityKey] [int] NOT NULL IDENTITY(1, 1),
[POS] [decimal] (18, 2) NULL,
[InterestReceivable] [decimal] (18, 2) NULL,
[IBPCExposureAmt] [decimal] (18, 2) NULL,
[OSBalance] [decimal] (18, 2) NULL,
[IBPCExposureinRs] [decimal] (16, 2) NULL,
[DateofIBPCreckoning] [date] NULL,
[DateofIBPCmarking] [date] NULL,
[MaturityDate] [date] NULL
) ON [PRIMARY]
GO
