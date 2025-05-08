CREATE TABLE [CurDat].[AdvAcOtherDetail]
(
[EntityKey] [bigint] NOT NULL,
[AccountEntityId] [int] NOT NULL,
[GovGurAmt] [decimal] (14, 0) NULL,
[SplCatg1Alt_Key] [smallint] NULL,
[SplCatg2Alt_Key] [smallint] NULL,
[RefinanceAgencyAlt_Key] [smallint] NULL,
[RefinanceAmount] [decimal] (14, 0) NULL,
[BankAlt_Key] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TransferAmt] [decimal] (14, 0) NULL,
[ProjectId] [int] NULL,
[ConsortiumId] [int] NULL,
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
[SplCatg3Alt_Key] [smallint] NULL,
[SplCatg4Alt_Key] [smallint] NULL,
[MocTypeAlt_Key] [int] NULL,
[GovGurExpDt] [date] NULL,
[SplFlag] [varchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [CurDat].[AdvAcOtherDetail] ADD CONSTRAINT [CK__AdvAcOthe__Effec__3A779186] CHECK (([EffectiveToTimeKey]=(49999)))
GO
ALTER TABLE [CurDat].[AdvAcOtherDetail] ADD CONSTRAINT [AdvAcOtherDetail_PK] PRIMARY KEY NONCLUSTERED ([EffectiveFromTimeKey], [EffectiveToTimeKey], [AccountEntityId]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
CREATE CLUSTERED INDEX [AdvAcOtherDetail_ClsIdx] ON [CurDat].[AdvAcOtherDetail] ([EntityKey]) ON [PRIMARY]
GO
