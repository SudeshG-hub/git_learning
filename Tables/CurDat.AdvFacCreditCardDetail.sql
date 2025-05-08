CREATE TABLE [CurDat].[AdvFacCreditCardDetail]
(
[EntityKey] [bigint] NOT NULL,
[AccountEntityId] [int] NOT NULL,
[CreditCardEntityId] [int] NOT NULL,
[CorporateUCIC_ID] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CorporateCustomerID] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Liability] [decimal] (18, 2) NULL,
[MinimumAmountDue] [decimal] (18, 2) NULL,
[CD] [int] NULL,
[Bucket] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DPD] [int] NULL,
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
[MocDate] [smalldatetime] NULL,
[AccountStatus] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AccountBlkCode2] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AccountBlkCode1] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ChargeoffY_N] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [CurDat].[AdvFacCreditCardDetail] ADD CONSTRAINT [CK__AdvFacCre__Effec__46DD686B] CHECK (([EffectiveToTimeKey]=(49999)))
GO
ALTER TABLE [CurDat].[AdvFacCreditCardDetail] ADD CONSTRAINT [AdvFacCreditCardDetail_CreditCardEntityId] PRIMARY KEY NONCLUSTERED ([AccountEntityId], [CreditCardEntityId], [EffectiveFromTimeKey], [EffectiveToTimeKey]) ON [PRIMARY]
GO
