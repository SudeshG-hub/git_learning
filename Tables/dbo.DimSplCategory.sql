CREATE TABLE [dbo].[DimSplCategory]
(
[SplCat_Key] [smallint] NOT NULL,
[SplCatAlt_Key] [smallint] NULL,
[SplCatName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SplCatShortName] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SplCatShortNameEnum] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SplCatGroup] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SplCatSubGroup] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SplCatSegment] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SplCatValidCode] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AssetClass] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Applicability] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SrcSysSplCatCode] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SrcSysSplCatName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DestSysSplCategoryCode] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
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
