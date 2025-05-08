CREATE TABLE [dbo].[DimTransactionSubTypeMaster]
(
[EntityKey] [int] NOT NULL IDENTITY(1, 1),
[Transaction_Sub_TypeAlt_Key] [int] NULL,
[Transaction_Sub_Type_Code] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Transaction_Sub_Type_Description] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SourceAlt_Key] [int] NULL,
[AuthorisationStatus] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EffectiveFromTimeKey] [int] NULL,
[EffectiveToTimeKey] [int] NULL,
[CreatedBy] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateCreated] [datetime] NULL,
[ModifiedBy] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateModified] [datetime] NULL,
[ApprovedBy] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateApproved] [datetime] NULL,
[TxnType] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
