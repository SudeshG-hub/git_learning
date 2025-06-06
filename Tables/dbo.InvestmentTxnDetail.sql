CREATE TABLE [dbo].[InvestmentTxnDetail]
(
[EntityKey] [int] NOT NULL IDENTITY(1, 1),
[InstrumentEntityID] [int] NULL,
[TxnEntityID] [int] NULL,
[AcqModeAlt_Key] [smallint] NULL,
[AcqDt] [date] NULL,
[AcqType] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AcqUnit] [decimal] (18, 2) NULL,
[AcqUnitPrice] [decimal] (8, 4) NULL,
[CurrConvRt] [decimal] (16, 4) NULL,
[AuthorisationStatus] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EffectiveFromTimeKey] [int] NULL,
[EffectiveToTimeKey] [int] NULL,
[CreatedBy] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateCreated] [smalldatetime] NULL,
[ModifiedBy] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateModified] [smalldatetime] NULL,
[ApprovedBy] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateApproved] [smalldatetime] NULL,
[D2Ktimestamp] [timestamp] NOT NULL,
[CurrCode] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AcqCost] [decimal] (16, 2) NULL,
[BookValue] [decimal] (16, 2) NULL,
[ExpenditurePaid] [decimal] (16, 2) NULL,
[Interestreceived] [decimal] (16, 2) NULL,
[MenuID] [int] NULL
) ON [PRIMARY]
GO
