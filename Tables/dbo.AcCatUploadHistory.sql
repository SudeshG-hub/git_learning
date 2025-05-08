CREATE TABLE [dbo].[AcCatUploadHistory]
(
[SlNo] [int] NULL,
[UPLOADID] [int] NULL,
[ACID] [varchar] (16) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomerID] [varchar] (16) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CategoryID] [varchar] (16) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Action] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FileName] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AuthorisationStatus] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EffectiveFromTimeKey] [int] NULL,
[EffectiveToTimeKey] [int] NULL,
[CreatedBy] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateCreated] [datetime] NULL,
[ModifyBy] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateModified] [date] NULL,
[ApprovedBy] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateApproved] [datetime] NULL,
[D2Ktimestamp] [timestamp] NOT NULL,
[FinalProv] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
