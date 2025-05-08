CREATE TABLE [CurDat].[AdvCustCommunicationDetail]
(
[EntityKey] [bigint] NOT NULL,
[CustomerEntityId] [int] NOT NULL,
[RelationEntityId] [int] NOT NULL,
[RelationAddEntityId] [int] NOT NULL,
[AddressCategoryAlt_Key] [int] NULL,
[AddressTypeAlt_Key] [int] NULL,
[Add1] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Add2] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Add3] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CountryAlt_Key] [smallint] NULL,
[DistrictAlt_Key] [smallint] NULL,
[CityAlt_Key] [smallint] NULL,
[PinCode] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustLocationCode] [varchar] (16) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[STD_Code_Res] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PhoneNo_Res] [varchar] (26) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[STD_Code_Off] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PhoneNo_Off] [varchar] (26) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FaxNo] [varchar] (26) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ExtensionNo] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ScrCrError] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RefCustomerId] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IsMainAddress] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AuthorisationStatus] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EffectiveFromTimeKey] [int] NOT NULL,
[EffectiveToTimeKey] [int] NOT NULL,
[CreatedBy] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateCreated] [smalldatetime] NULL,
[ModifiedBy] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateModified] [smalldatetime] NULL,
[ApprovedBy] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateApproved] [smalldatetime] NULL,
[D2Ktimestamp] [datetime] NOT NULL,
[DUNSNo] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CIBILPGId] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CityName] [varchar] (60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ScrCrErrorSeq] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UCIF_ID] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UCIFEntityID] [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [CurDat].[AdvCustCommunicationDetail] ADD CONSTRAINT [CK__AdvCustCo__Effec__3E48226A] CHECK (([EffectiveToTimeKey]=(49999)))
GO
ALTER TABLE [CurDat].[AdvCustCommunicationDetail] ADD CONSTRAINT [CK__AdvCustCo__Effec__3F3C46A3] CHECK (([EffectiveToTimeKey]=(49999)))
GO
ALTER TABLE [CurDat].[AdvCustCommunicationDetail] ADD CONSTRAINT [AdvCustCommunicationDetail_CustomerEntityId] PRIMARY KEY NONCLUSTERED ([RelationAddEntityId], [CustomerEntityId], [EffectiveFromTimeKey], [EffectiveToTimeKey]) ON [PRIMARY]
GO
