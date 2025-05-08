CREATE TABLE [dbo].[DimMOCType]
(
[MOCType_Key] [smallint] NOT NULL,
[MOCTypeAlt_Key] [smallint] NULL,
[MOCTypeName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MOCTypeShortName] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MOCTypeShortNameEnum] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MOCTypeGroup] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MOCTypeSubGroup] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MOCTypeSegment] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MOCTypeValidCode] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SrcSysMOCTypeCode] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SrcSysMOCTypeName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DestSysMOCTypeCode] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DestSysMOCTypeValidCode`] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EffectiveFromTimeKey] [int] NULL,
[EffectiveToTimeKey] [int] NULL,
[CreatedBy] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateCreated] [smalldatetime] NULL,
[ModifyBy] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateModified] [smalldatetime] NULL,
[ApprovedBy] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateApproved] [smalldatetime] NULL,
[D2Ktimestamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
