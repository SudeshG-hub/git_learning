CREATE TABLE [dbo].[DimBSRActivityMaster]
(
[BSR_Activity_Key] [smallint] NOT NULL IDENTITY(1, 1),
[BSR_ActivityAlt_Key] [smallint] NULL,
[BSR_ActivityCode] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BSR_ActivityName] [nvarchar] (4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BSR_ActivityDivision] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BSR_ActivitySubDivision] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BSR_ActivityGroup] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BSR_ActivitySubGroup] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AuthorisationStatus] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EffectiveFromTimeKey] [int] NULL,
[EffectiveToTimeKey] [int] NULL,
[CreatedBy] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateCreated] [datetime] NULL,
[ModifiedBy] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateModifie] [datetime] NULL,
[ApprovedBy] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateApproved] [datetime] NULL,
[D2Ktimestamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
