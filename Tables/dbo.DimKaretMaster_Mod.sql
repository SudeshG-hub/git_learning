CREATE TABLE [dbo].[DimKaretMaster_Mod]
(
[EntityKey] [int] NOT NULL IDENTITY(1, 1),
[KaretMasterAlt_Key] [int] NULL,
[KaretMasterValueName] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[KaretMasterValueDt] [smalldatetime] NULL,
[KaretMasterValueAmt] [decimal] (16, 2) NULL,
[SrcSysKaretValueCode] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SrcSysKaretValueName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DestSysKaretValueCode] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AuthorisationStatus] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EffectiveFromTimeKey] [int] NULL,
[EffectiveToTimeKey] [int] NULL,
[CreatedBy] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateCreated] [smalldatetime] NULL,
[ModifiedBy] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateModifie] [smalldatetime] NULL,
[ApprovedBy] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateApproved] [smalldatetime] NULL,
[D2Ktimestamp] [timestamp] NOT NULL,
[Changefields] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
