CREATE TABLE [dbo].[AccountFlaggingDetails_Mod]
(
[Entity_Key] [int] NOT NULL IDENTITY(1, 1),
[ACID] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Amount] [decimal] (18, 2) NULL,
[Date] [date] NULL,
[Action] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UploadTypeParameterAlt_Key] [int] NULL,
[AuthorisationStatus] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EffectiveFromTimeKey] [int] NULL,
[EffectiveToTimeKey] [int] NULL,
[Changes] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Remarks] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreatedBy] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateCreated] [datetime] NULL,
[ModifyBy] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateModified] [date] NULL,
[ApprovedBy] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateApproved] [date] NULL,
[UploadID] [int] NULL,
[ApprovedByFirstLevel] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateApprovedFirstLevel] [datetime] NULL
) ON [PRIMARY]
GO
