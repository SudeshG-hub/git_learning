CREATE TABLE [dbo].[SysSolutionParameter_16042022]
(
[Parameter_Key] [smallint] NOT NULL,
[ParameterAlt_Key] [smallint] NOT NULL,
[ParameterName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ParameterValue] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Remark] [varchar] (800) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AuthorisationStatus] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EffectiveFromTimeKey] [int] NULL,
[EffectiveToTimeKey] [int] NULL,
[CreatedBy] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateCreated] [smalldatetime] NULL,
[ModifyBy] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateModified] [smalldatetime] NULL,
[ApprovedBy] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateApproved] [smalldatetime] NULL,
[D2Ktimestamp] [timestamp] NOT NULL,
[AllowScreen] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ChangeEffectiveFromDt] [date] NULL,
[DataType] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AllowChar] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NonAllowChar] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
