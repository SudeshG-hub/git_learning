CREATE TABLE [dbo].[DimSubGLBACIDMapping]
(
[BACID_Key] [smallint] NOT NULL IDENTITY(1, 1),
[BACIDAlt_Key] [smallint] NOT NULL,
[OfficeGL_BACID] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CurrencyCode] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OfficeGL_AccountNumber] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OfficeGL_SubGL] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OfficeGL_BACIDDesc] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AuthorisationStatus] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EffectiveFromTimeKey] [int] NULL,
[EffectiveToTimeKey] [int] NULL,
[CreatedBy] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateCreated] [smalldatetime] NULL,
[ModifiedBy] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateModified] [smalldatetime] NULL,
[ApprovedBy] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateApproved] [smalldatetime] NULL,
[D2Ktimestamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
