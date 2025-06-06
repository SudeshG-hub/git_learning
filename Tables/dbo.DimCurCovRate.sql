CREATE TABLE [dbo].[DimCurCovRate]
(
[Currency_Key] [int] NOT NULL IDENTITY(1, 1),
[CurrencyAlt_Key] [smallint] NULL,
[CurrencyCode] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CurrencyName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ConvRate] [decimal] (18, 8) NULL,
[ReguConvRate] [float] NULL,
[ConvDate] [date] NULL,
[AuthorisationStatus] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EffectiveFromTimeKey] [int] NULL,
[EffectiveToTimeKey] [int] NULL,
[CreatedBy] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateCreated] [smalldatetime] NULL,
[ModifiedBy] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateModified] [smalldatetime] NULL,
[ApprovedBy] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateApproved] [smalldatetime] NULL,
[D2Ktimestamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
