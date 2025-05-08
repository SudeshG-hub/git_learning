CREATE TABLE [dbo].[Account1]
(
[Balance] [decimal] (16, 2) NULL,
[unserviedint] [decimal] (18, 2) NULL,
[FlgRestructure] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RestructureDate] [date] NULL,
[FLGFITL] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DFVAmt] [decimal] (16, 2) NULL,
[RePossession] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RepossessionDate] [date] NULL,
[WeakAccount] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[WeakAccountDate] [date] NULL,
[Sarfaesi] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SarfaesiDate] [date] NULL,
[FlgUnusualBounce] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UnusualBounceDate] [date] NULL,
[FlgUnClearedEffect] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UnClearedEffectDate] [date] NULL,
[AddlProvision] [decimal] (16, 2) NULL,
[FlgFraud] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FraudDate] [date] NULL,
[FlgMoc] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
