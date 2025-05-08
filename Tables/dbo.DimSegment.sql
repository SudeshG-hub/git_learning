CREATE TABLE [dbo].[DimSegment]
(
[EWS_Segment_Key] [smallint] NOT NULL IDENTITY(1, 1),
[EWS_SegmentAlt_Key] [smallint] NOT NULL,
[EWS_SegmentName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EWS_SegmentShortName] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EWS_SegmentShortNameEnum] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EWS_SegmentGroup] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EWS_SegmentSubGroup] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EWS_SegmentValidCode] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SegmentOrder] [smallint] NULL,
[Green] [smallint] NULL,
[Amber] [smallint] NULL,
[Red] [smallint] NULL,
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
