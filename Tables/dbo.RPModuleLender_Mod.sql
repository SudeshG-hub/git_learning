CREATE TABLE [dbo].[RPModuleLender_Mod]
(
[Entity_Key] [int] NOT NULL IDENTITY(1, 1),
[SrNo] [int] NULL,
[UploadID] [int] NULL,
[UCICID] [varchar] (16) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomerID] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BorrowerPAN] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BorrowerName] [varchar] (80) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LenderName] [varchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[InDefaultDate] [date] NULL,
[OutDefaultDate] [date] NULL,
[EffectiveFromTimeKey] [int] NULL,
[EffectiveToTimeKey] [int] NULL,
[AuthorisationStatus] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Changes] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Remark] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreatedBy] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateCreated] [datetime] NULL,
[ModifiedBy] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateModified] [datetime] NULL,
[ApprovedBy] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateApproved] [datetime] NULL,
[ApprovedByFirstLevel] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateApprovedFirstLevel] [datetime] NULL,
[ChangeField] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LenderName_altkey] [int] NULL
) ON [PRIMARY]
GO
