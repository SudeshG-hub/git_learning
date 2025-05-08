CREATE TABLE [dbo].[DimAssetClass_New]
(
[AssetClass_Key] [smallint] NOT NULL,
[AssetClassAlt_Key] [smallint] NOT NULL,
[AssetClassSubGroupOrderKey] [tinyint] NULL,
[AssetClassOrderKey] [tinyint] NULL,
[AssetClassName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AssetClassShortName] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AssetClassShortNameEnum] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AssetClassGroup] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AssetClassSubGroup] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AssetClassSegment] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AssetClassValidCode] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CIBILAssetClass] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SrcSysClassCode] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SrcSysClassName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DestSysAssetClassCode] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AuthorisationStatus] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EffectiveFromTimeKey] [int] NULL,
[EffectiveToTimeKey] [int] NULL,
[CreatedBy] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateCreated] [smalldatetime] NULL,
[ModifiedBy] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateModifie] [smalldatetime] NULL,
[ApprovedBy] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateApproved] [smalldatetime] NULL,
[D2Ktimestamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
