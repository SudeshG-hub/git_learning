CREATE TABLE [dbo].[DimReportFrequency]
(
[ReportFrequency_Key] [smallint] NOT NULL,
[ReportFrequencyAlt_Key] [smallint] NOT NULL,
[ReportFrequencyName] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ReportFrequencyShortName] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ReportFrequencyShortNameEnum] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ReportFrequencyGroup] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ReportFrequencySubGroup] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NoofDays] [smallint] NULL,
[ReportingDay] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Remark] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Maxdaystogenerate] [smallint] NULL,
[MaxAdvReminderindays] [smallint] NULL,
[MaxdaystosubmitRbi] [smallint] NULL,
[ReportFrequencyValidCode] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DestSysRephaseCode] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AuthorisationStatus] [char] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EffectiveFromTimeKey] [int] NULL,
[EffectiveToTimeKey] [int] NULL,
[CreatedBy] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateCreated] [smalldatetime] NULL,
[ModifiedBy] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateModifie] [smalldatetime] NULL,
[ApprovedBy] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateApproved] [smalldatetime] NULL,
[D2Ktimestamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
