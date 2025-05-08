CREATE TABLE [dbo].[SaletoARCSummary_Mod]
(
[Entity_Key] [int] NOT NULL IDENTITY(1, 1),
[UploadID] [int] NULL,
[SummaryID] [int] NULL,
[NoofAccounts] [int] NULL,
[TotalPOSinRs] [decimal] (18, 2) NULL,
[TotalInttReceivableinRs] [decimal] (18, 2) NULL,
[TotaloutstandingBalanceinRs] [decimal] (18, 2) NULL,
[ExposuretoARCinRs] [decimal] (18, 2) NULL,
[DateOfSaletoARC] [date] NULL,
[DateOfApproval] [date] NULL,
[AuthorisationStatus] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EffectiveFromTimeKey] [int] NULL,
[EffectiveToTimeKey] [int] NULL,
[CreatedBy] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateCreated] [smalldatetime] NULL,
[ModifyBy] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateModified] [smalldatetime] NULL,
[ApprovedBy] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateApproved] [smalldatetime] NULL,
[ApprovedByFirstLevel] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateApprovedFirstLevel] [smalldatetime] NULL,
[Action] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
