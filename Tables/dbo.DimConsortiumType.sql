CREATE TABLE [dbo].[DimConsortiumType]
(
[ConsortiumAlt_Key] [int] NOT NULL,
[Consortium_Key] [smallint] NOT NULL,
[Consortium_Name] [varchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ConsortiumShortName] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ConsortiumShortNameEnum] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ConsortiumGroup] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ConsortiumSubGroup] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ConsortiumSegment] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SrcSysConsortiumCode] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SrcSysConsortiumName] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AuthorisationStatus] [char] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EffectiveFromTimeKey] [int] NULL,
[EffectiveToTimeKey] [int] NULL,
[DateCreated] [smalldatetime] NULL,
[CreatedBy] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateModified] [smalldatetime] NULL,
[ModifyBy] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ApprovedBy] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateApproved] [smalldatetime] NULL,
[D2Ktimestamp] [timestamp] NULL
) ON [PRIMARY]
GO
