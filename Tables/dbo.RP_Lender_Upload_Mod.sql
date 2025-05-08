CREATE TABLE [dbo].[RP_Lender_Upload_Mod]
(
[EntityKey] [int] NOT NULL IDENTITY(1, 1),
[CustomerEntityID] [int] NULL,
[UCIC_ID] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomerID] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PAN_No] [varchar] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomerName] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LenderName] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[InDefaultDate] [datetime] NULL,
[OutOfDefaultDate] [datetime] NULL,
[ChangeFields] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Remarks] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EffectiveFromTimeKey] [int] NULL,
[EffectiveToTimeKey] [int] NULL,
[AuthorisationStatus] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreatedBy] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateCreated] [smalldatetime] NULL,
[ModifiedBy] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateModified] [smalldatetime] NULL,
[ApprovedBy] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateApproved] [smalldatetime] NULL
) ON [PRIMARY]
GO
