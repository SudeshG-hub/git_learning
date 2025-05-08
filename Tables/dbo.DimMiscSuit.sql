CREATE TABLE [dbo].[DimMiscSuit]
(
[LegalMiscSuit_Key] [smallint] NOT NULL,
[LegalMiscSuitAlt_Key] [smallint] NULL,
[LegalMiscSuitName] [nvarchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LegalMiscSuitShortName] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LegalMiscSuitShortNameEnum] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LegalMiscSuitGroup] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LegalMiscSuitGroupOrderKey] [tinyint] NULL,
[LegalMiscSuitSubGroup] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LegalMiscSuitSubGroupOrderKey] [tinyint] NULL,
[LegalMiscSuitSegment] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LegalMiscSuitValidCode] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
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
