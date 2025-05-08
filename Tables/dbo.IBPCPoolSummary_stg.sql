CREATE TABLE [dbo].[IBPCPoolSummary_stg]
(
[EntityKey] [int] NOT NULL IDENTITY(1, 1),
[UploadID] [int] NULL,
[SummaryID] [int] NULL,
[PoolID] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PoolName] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PoolType] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BalanceOutstanding] [decimal] (18, 2) NULL,
[IBPCExposureAmt] [decimal] (18, 2) NULL,
[IBPCReckoningDate] [date] NULL,
[IBPCMarkingDate] [date] NULL,
[MaturityDate] [date] NULL,
[filname] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NoOfAccount] [int] NULL,
[TotalPosBalance] [decimal] (18, 2) NULL,
[TotalInttReceivable] [decimal] (18, 2) NULL
) ON [PRIMARY]
GO
