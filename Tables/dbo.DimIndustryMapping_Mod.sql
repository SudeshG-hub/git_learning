CREATE TABLE [dbo].[DimIndustryMapping_Mod]
(
[IndustryAlt_Key] [smallint] NULL,
[IndustryOrderKey] [tinyint] NULL,
[IndustryName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IndustryShortName] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IndustryShortNameEnum] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IndustryGroup] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IndustrySubGroup] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IndustrySegment] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IndustryValidCode] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SrcSysIndustryCode] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SrcSysIndustryName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DestSysIndustryCode] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
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
[SourceAlt_Key] [int] NULL,
[Industry_Key] [int] NOT NULL IDENTITY(1, 1),
[IndustryMappingAlt_Key] [int] NULL
) ON [PRIMARY]
GO
