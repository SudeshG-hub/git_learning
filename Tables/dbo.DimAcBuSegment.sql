CREATE TABLE [dbo].[DimAcBuSegment]
(
[AcBuSegment_Key] [smallint] NOT NULL,
[AcBuSegmentAlt_Key] [smallint] NOT NULL,
[SourceAlt_Key] [smallint] NULL,
[AcBuSegmentCode] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AcBuRevisedSegmentCode] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AcBuSegmentDescription] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AcBuSegmentShortName] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AcBuSegmentShortNameEnum] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AcBuSegmentSubGroup] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AcBuSegmentGroup] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AcBuSegmentValidCode] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AuthorisationStatus] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EffectiveFromTimeKey] [int] NULL,
[EffectiveToTimeKey] [int] NULL,
[CreatedBy] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateCreated] [datetime] NULL,
[ModifyBy] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateModified] [date] NULL,
[ApprovedBy] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateApproved] [datetime] NULL,
[D2Ktimestamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
