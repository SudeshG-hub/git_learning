CREATE TABLE [dbo].[SolutionGlobalParameter_Mod]
(
[EntityKey] [int] NOT NULL IDENTITY(1, 1),
[ParameterAlt_Key] [int] NULL,
[ParameterName] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ParameterValueAlt_Key] [int] NULL,
[ParameterNatureAlt_Key] [int] NULL,
[From_Date] [datetime] NULL,
[To_Date] [datetime] NULL,
[ParameterStatusAlt_Key] [int] NULL,
[AuthorisationStatus] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Changes] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Remark] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EffectiveFromTimeKey] [int] NULL,
[EffectiveToTimeKey] [int] NULL,
[CreatedBy] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateCreated] [smalldatetime] NULL,
[ApprovedBy] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateApproved] [smalldatetime] NULL,
[ModifiedBy] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateModified] [smalldatetime] NULL
) ON [PRIMARY]
GO
