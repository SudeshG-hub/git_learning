CREATE TABLE [PRO].[LastCreditDtAccountCal_09032022]
(
[EntityKey] [bigint] NOT NULL IDENTITY(1, 1),
[CustomerAcID] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AccountEntityId] [int] NULL,
[LastCrDate] [datetime] NULL,
[LasttoLastCrDate] [datetime] NULL,
[ReturnedAmt] [decimal] (18, 2) NULL,
[CreditAmt] [decimal] (18, 2) NULL,
[DebitAmt] [decimal] (18, 2) NULL,
[Status] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Credit_Flg] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Acc_SrNo] [int] NULL,
[EffectiveFromTimeKey] [int] NULL,
[EffectiveToTimeKey] [int] NULL
) ON [PRIMARY]
GO
