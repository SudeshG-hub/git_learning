CREATE TABLE [dbo].[DimInstrumentTypeMapping]
(
[InstrumentTypeAlt_Key] [smallint] NULL,
[InstrumentTypeName] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[InstrumentTypeShortName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[InstrumentTypeShortNameEnum] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[InstrumentTypeGroup] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[InstrumentTypeSubGroup] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AuthorisationStatus] [char] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
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
[InstrumentTypeMappingAlt_Key] [int] NULL,
[InstrumentType_Key] [smallint] NOT NULL IDENTITY(1, 1),
[SrcSysInstrumentTypeCode] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SrcSysInstrumentTypeName] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
