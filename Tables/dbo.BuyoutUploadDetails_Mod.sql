CREATE TABLE [dbo].[BuyoutUploadDetails_Mod]
(
[EntityKey] [int] NOT NULL IDENTITY(1, 1),
[SlNo] [int] NULL,
[UploadID] [int] NULL,
[DateofData] [date] NULL,
[ReportDate] [date] NULL,
[CustomerAcID] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SchemeCode] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NPA_ClassSeller] [varchar] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NPA_DateSeller] [date] NULL,
[DPD_Seller] [smallint] NULL,
[PeakDPD] [smallint] NULL,
[PeakDPD_Date] [date] NULL,
[AuthorisationStatus] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EffectiveFromTimeKey] [int] NULL,
[EffectiveToTimeKey] [int] NULL,
[CreatedBy] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateCreated] [date] NULL,
[ModifyBy] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateModified] [date] NULL,
[ApprovedBy] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateApproved] [date] NULL,
[ChangeFields] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ApprovedByFirstLevel] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateApprovedFirstLevel] [datetime] NULL
) ON [PRIMARY]
GO
