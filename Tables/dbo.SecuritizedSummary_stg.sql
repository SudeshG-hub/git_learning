CREATE TABLE [dbo].[SecuritizedSummary_stg]
(
[EntityKey] [int] NOT NULL IDENTITY(1, 1),
[UploadID] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SummaryID] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PoolID] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PoolName] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SecuritisationType] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[POS] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SecuritisationExposureAmt] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SecuritisationReckoningDate] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SecuritisationMarkingDate] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MaturityDate] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[filname] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NoOfAccount] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TotalPosBalance] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TotalInttReceivable] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Action] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[InterestAccruedinRs] [decimal] (16, 2) NULL
) ON [PRIMARY]
GO
