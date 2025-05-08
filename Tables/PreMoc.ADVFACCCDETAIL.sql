CREATE TABLE [PreMoc].[ADVFACCCDETAIL]
(
[AccountEntityId] [int] NOT NULL,
[AdhocDt] [date] NULL,
[AdhocAmt] [decimal] (14, 0) NULL,
[ContExcsSinceDt] [date] NULL,
[DerecognisedInterest1] [decimal] (14, 0) NULL,
[DerecognisedInterest2] [decimal] (14, 0) NULL,
[ClaimType] [varchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ClaimCoverAmt] [decimal] (14, 0) NULL,
[ClaimLodgedDt] [date] NULL,
[ClaimLodgedAmt] [decimal] (14, 0) NULL,
[ClaimRecvDt] [date] NULL,
[ClaimReceivedAmt] [decimal] (14, 0) NULL,
[ClaimRate] [decimal] (14, 0) NULL,
[RefSystemAcid] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AuthorisationStatus] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EffectiveFromTimeKey] [int] NOT NULL,
[EffectiveToTimeKey] [int] NOT NULL,
[CreatedBy] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateCreated] [smalldatetime] NULL,
[ModifiedBy] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateModified] [smalldatetime] NULL,
[ApprovedBy] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateApproved] [smalldatetime] NULL,
[D2Ktimestamp] [timestamp] NOT NULL,
[MocStatus] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MocDate] [smalldatetime] NULL,
[MocTypeAlt_Key] [int] NULL,
[AdhocExpiryDate] [date] NULL,
[ENTITYKEY] [int] NOT NULL IDENTITY(1, 1),
[StockStmtDt] [date] NULL
) ON [PRIMARY]
GO
ALTER TABLE [PreMoc].[ADVFACCCDETAIL] ADD CONSTRAINT [AdvFacCCDetail_PK] PRIMARY KEY NONCLUSTERED ([EffectiveFromTimeKey], [EffectiveToTimeKey], [AccountEntityId]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
