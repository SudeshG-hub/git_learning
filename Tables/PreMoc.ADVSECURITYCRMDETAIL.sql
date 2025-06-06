CREATE TABLE [PreMoc].[ADVSECURITYCRMDETAIL]
(
[AccountEntityId] [int] NOT NULL,
[CustomerEntityID] [int] NULL,
[SecurityEntityID] [int] NOT NULL,
[CRMEntityID] [int] NULL,
[CRMSecurityAlt_Key] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UniqueRefNo] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[HolderName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DtOfIssue] [date] NULL,
[DtOfMaturity] [date] NULL,
[CurrencyAlt_Key] [smallint] NULL,
[NoOfUnit] [int] NULL,
[Facevalue] [decimal] (14, 0) NULL,
[IntRate] [decimal] (5, 2) NULL,
[CurrentValue] [decimal] (14, 0) NULL,
[Rating] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DoubleCounting] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Karat] [smallint] NULL,
[Grams] [decimal] (9, 3) NULL,
[EligibleForBaselII] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CRMSupCutFactor] [decimal] (5, 2) NULL,
[CRMCurrMismatchCut] [decimal] (5, 2) NULL,
[CRMRescMatuMismatch] [decimal] (5, 2) NULL,
[FormStatus] [char] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EntryType] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ScrCrError] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AuthorisationStatus] [char] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EffectiveFromTimeKey] [int] NULL,
[EffectiveToTimeKey] [int] NOT NULL,
[CreatedBy] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateCreated] [smalldatetime] NULL,
[ModifiedBy] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateModified] [smalldatetime] NULL,
[ApprovedBy] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateApproved] [smalldatetime] NULL,
[D2Ktimestamp] [timestamp] NOT NULL,
[MocTypeAlt_Key] [int] NULL,
[MocStatus] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MocDate] [smalldatetime] NULL,
[HOSecurityAlt_Key] [smallint] NULL,
[ENTITYKEY] [int] NOT NULL IDENTITY(1, 1)
) ON [PRIMARY]
GO
