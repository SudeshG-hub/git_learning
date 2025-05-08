CREATE TABLE [dbo].[IBPCPoolDetail_stg_29042022]
(
[SrNo] [int] NULL,
[UploadID] [int] NULL,
[SummaryID] [int] NULL,
[PoolID] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PoolName] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PoolType] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomerID] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AccountID] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PrincipalOutstandinginRs] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[InterestReceivableinRs] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OSBalanceinRs] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IBPCExposureinRs] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateofIBPCreckoning] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateofIBPCmarking] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MaturityDate] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[filname] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
