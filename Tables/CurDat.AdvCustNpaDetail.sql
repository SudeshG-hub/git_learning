CREATE TABLE [CurDat].[AdvCustNpaDetail]
(
[ENTITYKEY] [bigint] NOT NULL,
[CustomerEntityId] [int] NOT NULL,
[Cust_AssetClassAlt_Key] [smallint] NULL,
[NPADt] [date] NULL,
[LastInttChargedDt] [date] NULL,
[DbtDt] [date] NULL,
[LosDt] [date] NULL,
[DefaultReason1Alt_Key] [smallint] NULL,
[DefaultReason2Alt_Key] [smallint] NULL,
[StaffAccountability] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LastIntBooked] [date] NULL,
[RefCustomerID] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AuthorisationStatus] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EffectiveFromTimeKey] [int] NOT NULL,
[EffectiveToTimeKey] [int] NOT NULL,
[CreatedBy] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateCreated] [date] NULL,
[ModifiedBy] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateModified] [date] NULL,
[ApprovedBy] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateApproved] [date] NULL,
[D2Ktimestamp] [datetime] NOT NULL,
[MocStatus] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MocDate] [date] NULL,
[MocTypeAlt_Key] [int] NULL,
[NPA_Reason] [varchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [CurDat].[AdvCustNpaDetail] ADD CONSTRAINT [CK__AdvCustNp__Effec__1BBE003C] CHECK (([EffectiveToTimeKey]=(49999)))
GO
ALTER TABLE [CurDat].[AdvCustNpaDetail] ADD CONSTRAINT [CK__AdvCustNp__Effec__1CB22475] CHECK (([EffectiveToTimeKey]=(49999)))
GO
ALTER TABLE [CurDat].[AdvCustNpaDetail] ADD CONSTRAINT [CK__AdvCustNp__Effec__1DA648AE] CHECK (([EffectiveToTimeKey]=(49999)))
GO
ALTER TABLE [CurDat].[AdvCustNpaDetail] ADD CONSTRAINT [AdvCustNPADetail_AccountEntityID] PRIMARY KEY NONCLUSTERED ([CustomerEntityId], [EffectiveFromTimeKey], [EffectiveToTimeKey]) ON [PRIMARY]
GO
