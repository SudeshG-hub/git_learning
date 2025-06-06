CREATE TABLE [dbo].[SecuritizedFinalACDetail]
(
[EntityKey] [int] NOT NULL IDENTITY(1, 1),
[SummaryID] [int] NULL,
[PoolID] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PoolName] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomerID] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AccountID] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AuthorisationStatus] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EffectiveFromTimeKey] [int] NULL,
[EffectiveToTimeKey] [int] NULL,
[CreatedBy] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateCreated] [smalldatetime] NULL,
[ModifyBy] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateModified] [smalldatetime] NULL,
[ApprovedBy] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateApproved] [smalldatetime] NULL,
[D2Ktimestamp] [timestamp] NOT NULL,
[ChangeFields] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[POS] [decimal] (18, 2) NULL,
[InterestReceivable] [decimal] (18, 2) NULL,
[SourceAlt_Key] [int] NULL,
[SourceName] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomerName] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FlagAlt_Key] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AccountBalance] [decimal] (18, 2) NULL,
[ExposureAmount] [decimal] (18, 2) NULL,
[Remark] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SecuritisationType] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ScrOutDate] [date] NULL,
[ScrInDate] [date] NULL,
[poolType] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MaturityDate] [date] NULL,
[SecMarkingDate] [date] NULL,
[InterestAccruedinRs] [decimal] (18, 2) NULL
) ON [PRIMARY]
GO
