CREATE TABLE [dbo].[DimReasonForWillfulDefault]
(
[ReasonAlt_Key] [int] NOT NULL,
[Description] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DelSta] [nvarchar] (7) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EditFlag] [nvarchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Reason_Key] [smallint] NOT NULL,
[EffectiveFromTimeKey] [int] NULL,
[EffectiveToTimeKey] [int] NULL,
[DateCreated] [smalldatetime] NULL,
[CreatedBy] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateModified] [smalldatetime] NULL,
[ModifyBy] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ApprovedBy] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[D2Ktimestamp] [timestamp] NULL,
[RecordStatus] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
