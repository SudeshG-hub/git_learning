CREATE TABLE [dbo].[SecuritizedFinalACSummary]
(
[EntityKey] [int] NOT NULL IDENTITY(1, 1),
[SummaryID] [int] NULL,
[PoolID] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PoolName] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SecuritisationType] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[POS] [decimal] (18, 2) NULL,
[SecuritisationExposureAmt] [decimal] (18, 2) NULL,
[SecuritisationReckoningDate] [date] NULL,
[SecuritisationMarkingDate] [date] NULL,
[SecuritisationPortfolio] [decimal] (18, 2) NULL,
[MaturityDate] [date] NULL,
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
[NoOfAccount] [int] NULL,
[TotalPosBalance] [decimal] (18, 2) NULL,
[TotalInttReceivable] [decimal] (18, 2) NULL
) ON [PRIMARY]
GO
