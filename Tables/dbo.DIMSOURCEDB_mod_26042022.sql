CREATE TABLE [dbo].[DIMSOURCEDB_mod_26042022]
(
[Source_Key] [int] NOT NULL IDENTITY(1, 1),
[SourceAlt_Key] [int] NULL,
[SourceName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SourceShortName] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SourceShortNameEnum] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SourceGroup] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SourceSubGroup] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SourceSegment] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SourceDBName] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Changes] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Remarks] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EffectiveFromTimeKey] [int] NULL,
[EffectiveToTimeKey] [int] NULL,
[RecordStatus] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateCreated] [datetime] NULL,
[CreatedBy] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ModifiedBy] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateModified] [datetime] NULL,
[ApprovedBy] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[D2Ktimestamp] [timestamp] NOT NULL,
[AuthorisationStatus] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateApproved] [datetime] NULL,
[ChangeFields] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
