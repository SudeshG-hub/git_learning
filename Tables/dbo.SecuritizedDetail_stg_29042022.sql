CREATE TABLE [dbo].[SecuritizedDetail_stg_29042022]
(
[EntityKey] [int] NOT NULL IDENTITY(1, 1),
[SrNo] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UploadID] [int] NULL,
[SummaryID] [int] NULL,
[PoolID] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PoolName] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SecuritisationType] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AccountID] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomerID] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PrincipalOutstandinginRs] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[InterestReceivableinRs] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OSBalanceinRs] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[InterestAccruedinRs] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SecuritisationExposureinRs] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateofSecuritisationreckoning] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateofSecuritisationmarking] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MaturityDate] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Action] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[filname] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
