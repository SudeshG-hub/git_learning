CREATE TABLE [dbo].[Securitized]
(
[EntityKey] [int] NOT NULL IDENTITY(1, 1),
[SrNo] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UploadID] [int] NULL,
[SummaryID] [int] NULL,
[PoolID] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PoolName] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PoolType] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AccountID] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[InterestAccruedinRs] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SecuritisationExposureinRs] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateofSecuritisationmarking] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MaturityDate] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Action] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[filname] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ErrorMessage] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ErrorinColumn] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Srnooferroneousrows] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
