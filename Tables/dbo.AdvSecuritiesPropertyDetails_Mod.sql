CREATE TABLE [dbo].[AdvSecuritiesPropertyDetails_Mod]
(
[EntityKey] [int] NOT NULL IDENTITY(1, 1),
[CustomerEntityId] [int] NULL,
[AccountEntityID] [int] NULL,
[SecurityEntityID] [int] NULL,
[North] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[South] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[East] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[West] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LeasedFreeHold] [decimal] (18, 2) NULL,
[LandBuildTypeAlt_Key] [smallint] NULL,
[BuiltUpArea] [decimal] (16, 2) NULL,
[CarpetArea] [decimal] (16, 2) NULL,
[LandArea] [decimal] (16, 2) NULL,
[Location] [varchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Longitude] [decimal] (8, 4) NULL,
[Latitude] [decimal] (8, 4) NULL,
[Inspection] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OwnerShipTypeAlt_key] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RegWithCRESAI] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CRESAIRegNo] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CRESAIRegdt] [date] NULL,
[ValuationDt] [date] NULL,
[ValueInfo] [decimal] (9, 0) NULL,
[ValuerName] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[chkOther] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MocTypeAlt_Key] [int] NULL,
[MocStatus] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MocDate] [smalldatetime] NULL,
[AuthorisationStatus] [char] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EffectiveFromTimeKey] [int] NULL,
[EffectiveToTimeKey] [int] NULL,
[CreatedBy] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateCreated] [smalldatetime] NULL,
[ModifiedBy] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateModified] [smalldatetime] NULL,
[ApprovedBy] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateApproved] [smalldatetime] NULL,
[D2Ktimestamp] [timestamp] NOT NULL,
[ChangeFields] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
