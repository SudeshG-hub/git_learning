CREATE TABLE [dbo].[DimLegalNatureOfActivity]
(
[LegalNatureOfActivity_Key] [smallint] NOT NULL,
[LegalNatureOfActivityAlt_Key] [smallint] NULL,
[LegalNatureOfActivityName] [nvarchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LegalNatureOfActivityShortName] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LegalNatureOfActivityShortNameEnum] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LegalNatureOfActivityGroup] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LegalNatureOfActivityGroupOrderKey] [tinyint] NULL,
[LegalNatureOfActivitySubGroup] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LegalNatureOfActivitySubGroupOrderKey] [tinyint] NULL,
[LegalNatureOfActivitySegment] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LegalNatureOfActivityValidCode] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SrcSysClassCode] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EffectiveFromTimeKey] [int] NOT NULL,
[EffectiveToTimeKey] [int] NOT NULL,
[DateCreated] [smalldatetime] NULL,
[CreatedBy] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateModified] [smalldatetime] NULL,
[ModifyBy] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ApprovedBy] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[D2Ktimestamp] [timestamp] NULL
) ON [PRIMARY]
GO
