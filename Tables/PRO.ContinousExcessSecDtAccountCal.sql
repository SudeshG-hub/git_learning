CREATE TABLE [PRO].[ContinousExcessSecDtAccountCal]
(
[EntityKey] [bigint] NOT NULL IDENTITY(1, 1),
[CustomerAcID] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AccountEntityId] [int] NULL,
[Balance] [decimal] (18, 2) NULL,
[SecurityValue] [decimal] (18, 2) NULL,
[ContinousExcessSecDt] [date] NULL,
[EffectiveFromTimeKey] [int] NULL,
[EffectiveToTimeKey] [int] NULL
) ON [PRIMARY]
GO
