CREATE TABLE [dbo].[DimGLProduct]
(
[GLProduct_Key] [smallint] NOT NULL,
[GLProductAlt_Key] [smallint] NOT NULL,
[GLCode] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[GLName] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ProductCode] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ProductName] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[GLType] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[GLSta] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[GLGroup] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FacilityType] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FacilitySubType] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ExpType] [smallint] NULL,
[Bsr1aCode] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RetailGL] [smallint] NULL,
[SrcSysModule] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SancFacilityType] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AssetClassGrp] [varchar] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LcIssued] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CIBILCreditType] [varchar] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NewFacilityAllowed] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[GovGurCover] [smallint] NULL,
[AssetClass] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ApplicableSubSector] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RepaySingleBullet] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CashFlowEnable] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RepayAllowFreq] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[GLProductValidCode] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SrcSysGLCode] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SrcSysGLName] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DestSysGLProductAdvTypeCode] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DestSysGLProductCode] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EI_Scheme_Flag] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[GLAdvGrp] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AuthorisationStatus] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EffectiveFromTimeKey] [int] NULL,
[EffectiveToTimeKey] [int] NULL,
[CreatedBy] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateCreated] [smalldatetime] NULL,
[ModifiedBy] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateModified] [smalldatetime] NULL,
[ApprovedBy] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateApproved] [smalldatetime] NULL,
[D2Ktimestamp] [timestamp] NOT NULL,
[CIBIL_ConsumerAcType] [char] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AcTypeAlt_Key] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
