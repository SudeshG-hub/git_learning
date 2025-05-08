CREATE TABLE [CurDat].[AdvCreditCardBalanceDetail]
(
[EntityKey] [bigint] NOT NULL,
[AccountEntityId] [int] NOT NULL,
[CreditCardEntityId] [int] NOT NULL,
[Balance_POS] [decimal] (18, 2) NULL,
[Balance_LOAN] [decimal] (18, 2) NULL,
[Balance_INT] [decimal] (18, 2) NULL,
[Balance_GST] [decimal] (18, 2) NULL,
[Balance_FEES] [decimal] (18, 2) NULL,
[RefSystemAcId] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AuthorisationStatus] [char] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EffectiveFromTimeKey] [int] NOT NULL,
[EffectiveToTimeKey] [int] NOT NULL,
[CreatedBy] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateCreated] [smalldatetime] NULL,
[ModifiedBy] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateModified] [smalldatetime] NULL,
[ApprovedBy] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateApproved] [smalldatetime] NULL,
[D2Ktimestamp] [datetime] NOT NULL,
[MocStatus] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MocDate] [smalldatetime] NULL
) ON [PRIMARY]
GO
ALTER TABLE [CurDat].[AdvCreditCardBalanceDetail] ADD CONSTRAINT [CK__AdvCredit__Effec__3D53FE31] CHECK (([EffectiveToTimeKey]=(49999)))
GO
ALTER TABLE [CurDat].[AdvCreditCardBalanceDetail] ADD CONSTRAINT [AdvCreditCardBalanceDetail_CreditCardEntityId] PRIMARY KEY NONCLUSTERED ([AccountEntityId], [CreditCardEntityId], [EffectiveFromTimeKey], [EffectiveToTimeKey]) ON [PRIMARY]
GO
