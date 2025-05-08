CREATE TABLE [dbo].[DimBSR_Industry]
(
[BSR_Industry_Key] [smallint] NOT NULL,
[BSR_IndustryAlt_Key] [smallint] NULL,
[BSR_IndustryCode] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BSR_IndustryOrderKey] [tinyint] NULL,
[BSR_IndustryName] [nvarchar] (4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BSR_IndustryShortName] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BSR_IndustryShortNameEnum] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BSR_IndustryGroup] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BSR_IndustrySubGroup] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BSR_IndustrySegment] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BSR_IndustryValidCode] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SrcSysBSR_IndustryCode] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SrcSysBSR_IndustryName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DestSysBSR_IndustryCode] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AuthorisationStatus] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EffectiveFromTimeKey] [int] NULL,
[EffectiveToTimeKey] [int] NULL,
[CreatedBy] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateCreated] [datetime] NULL,
[ModifiedBy] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateModifie] [datetime] NULL,
[ApprovedBy] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateApproved] [datetime] NULL,
[D2Ktimestamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
