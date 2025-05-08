CREATE TABLE [dbo].[StockStatement_Mod]
(
[Entity_Key] [int] NOT NULL IDENTITY(1, 1),
[SrNo] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UploadID] [int] NULL,
[CIF] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AccountID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomerLimitSuffix] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[StockStamentDt] [date] NULL,
[AccountEntityID] [int] NULL,
[AuthorisationStatus] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EffectiveFromTimeKey] [int] NULL,
[EffectiveToTimeKey] [int] NULL,
[CreatedBy] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateCreated] [smalldatetime] NULL,
[ModifiedBy] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateModified] [smalldatetime] NULL,
[ApprovedBy] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateApproved] [smalldatetime] NULL,
[FirstLevelApprovedBy] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FirstLevelDateApproved] [smalldatetime] NULL,
[ChangeFiels] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
