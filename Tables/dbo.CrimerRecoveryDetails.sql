CREATE TABLE [dbo].[CrimerRecoveryDetails]
(
[Entitykey] [int] NOT NULL IDENTITY(1, 1),
[CrimeEntityId] [int] NULL,
[CrimeRecEntityId] [int] NULL,
[StatusAlt_Key] [tinyint] NULL,
[StatusDate] [date] NULL,
[RecoverAmt] [decimal] (18, 2) NULL,
[Remarks] [varchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AuthorisationStatus] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EffectiveFromTimeKey] [int] NULL,
[EffectiveToTimeKey] [int] NULL,
[CreatedBy] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateCreated] [smalldatetime] NULL,
[ModifiedBy] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateModified] [smalldatetime] NULL,
[ApprovedBy] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateApproved] [smalldatetime] NULL,
[D2Ktimestamp] [timestamp] NOT NULL,
[EffectiveFromDate] [date] NULL
) ON [PRIMARY]
GO
