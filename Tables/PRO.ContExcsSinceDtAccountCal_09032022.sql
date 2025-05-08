CREATE TABLE [PRO].[ContExcsSinceDtAccountCal_09032022]
(
[EntityKey] [bigint] NOT NULL IDENTITY(1, 1),
[CustomerAcID] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AccountEntityId] [int] NULL,
[SanctionAmt] [decimal] (18, 2) NULL,
[SanctionDt] [date] NULL,
[Balance] [decimal] (18, 2) NULL,
[DrawingPower] [decimal] (18, 2) NULL,
[ContExcsSinceDt] [date] NULL,
[EffectiveFromTimeKey] [int] NULL,
[EffectiveToTimeKey] [int] NULL
) ON [PRIMARY]
GO
