CREATE TABLE [dbo].[DimDesignation]
(
[Designation_Key] [smallint] NOT NULL,
[DesignationAlt_Key] [smallint] NOT NULL,
[DesignationName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DesignationShortName] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DesignationShortNameEnum] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DesignationGroup] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DesignationSubGroup] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DesignationSegment] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DesignationValidCode] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SrcSysDesignationCode] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SrcSysDesignationName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DestSysDesignationCode] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AuthorisationStatus] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EffectiveFromTimeKey] [int] NULL,
[EffectiveToTimeKey] [int] NULL,
[CreatedBy] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateCreated] [smalldatetime] NULL,
[ModifiedBy] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateModified] [smalldatetime] NULL,
[ApprovedBy] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateApproved] [smalldatetime] NULL,
[D2Ktimestamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
