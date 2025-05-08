CREATE TABLE [dbo].[DimUserParameters1]
(
[EntityKey] [smallint] NOT NULL IDENTITY(1, 1),
[SeqNo] [smallint] NOT NULL,
[ParameterType] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ShortNameEnum] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ParameterValue] [int] NULL,
[MinValue] [smallint] NULL,
[MaxValue] [smallint] NULL,
[AuthorisationStatus] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
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
