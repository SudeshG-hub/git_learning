CREATE TABLE [dbo].[RP_Lender_Details]
(
[EntityKey] [int] NOT NULL IDENTITY(1, 1),
[CustomerID] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ReportingLenderAlt_Key] [smallint] NULL,
[InDefaultDate] [datetime] NULL,
[OutOfDefaultDate] [datetime] NULL,
[DefaultStatus] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EffectiveFromTimeKey] [int] NULL,
[EffectiveToTimeKey] [int] NULL,
[AuthorisationStatus] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreatedBy] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateCreated] [smalldatetime] NULL,
[ModifiedBy] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateModified] [smalldatetime] NULL,
[ApprovedBy] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateApproved] [smalldatetime] NULL,
[RPDetailsActiveCustomer_EntityKey] [int] NULL,
[ApprovedByFirstLevel] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateApprovedFirstLevel] [datetime] NULL,
[Status] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
