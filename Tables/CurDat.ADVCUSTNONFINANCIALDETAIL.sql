CREATE TABLE [CurDat].[ADVCUSTNONFINANCIALDETAIL]
(
[ENTITYKEY] [bigint] NOT NULL IDENTITY(1, 1),
[CustomerEntityId] [int] NOT NULL,
[BranchCode] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Cust_LADDt] [date] NULL,
[Cust_DocumentDt] [date] NULL,
[Cust_LastReviewDueDt] [date] NULL,
[Cust_ReviewTypeAlt_key] [smallint] NULL,
[Cust_ReviewDt] [date] NULL,
[Cust_NextReviewDueDt] [date] NULL,
[Cust_ReviewAuthAlt_Key] [smallint] NULL,
[ReviewByEmpCode] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RefCustomerId] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AuthorisationStatus] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EffectiveFromTimeKey] [int] NOT NULL,
[EffectiveToTimeKey] [int] NOT NULL,
[CreatedBy] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateCreated] [smalldatetime] NULL,
[ModifiedBy] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateModified] [smalldatetime] NULL,
[ApprovedBy] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateApproved] [smalldatetime] NULL,
[D2Ktimestamp] [timestamp] NOT NULL,
[MocStatus] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MocDate] [smalldatetime] NULL,
[MocTypeAlt_Key] [int] NULL,
[Cust_ReviewAuthLevelAlt_Key] [smallint] NULL
) ON [PRIMARY]
GO
