CREATE TABLE [dbo].[DimParameter]
(
[DimParameter_Key] [smallint] NOT NULL IDENTITY(1, 1),
[DimParameterName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Parameter_Key] [int] NULL,
[ParameterAlt_Key] [smallint] NULL,
[ParameterName] [varchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ParameterShortName] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ParameterShortNameEnum] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SrcSysParameterCode] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SrcSysParameterName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DestSysarameterCode] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
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
[CibilCode] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
