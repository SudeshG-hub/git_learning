CREATE TABLE [dbo].[DimFarmerCat]
(
[FarmerCat_Key] [smallint] NOT NULL,
[FarmerCatAlt_Key] [smallint] NULL,
[FarmerCatOrderKey] [tinyint] NULL,
[FarmerCatName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FarmerCatShortName] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FarmerCatShortNameEnum] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FarmerCatGroup] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FarmerCatSubGroup] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FarmerCatSegment] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FarmerCatValidCode] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SrcSysFarmerCatCode] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SrcSysFarmerCatName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DestSysFarmerCatCode] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
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
