CREATE TABLE [PRO].[ChangedMocAclStatus]
(
[EntityKey] [int] NOT NULL,
[RefCustomerID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomerEntityID] [int] NULL,
[SourceSystemCustomerID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MOC_AssetClass_Alt_Key] [smallint] NULL,
[Old_AssetClassAlt_Key] [smallint] NULL,
[MocTypeAlt_Key] [smallint] NULL,
[MocDate] [date] NULL,
[UserID] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EffectiveFromTimeKey] [int] NULL,
[EffectiveToTimeKey] [int] NULL,
[CreatedBy] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateCreated] [date] NULL,
[ModifiedBy] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateModified] [date] NULL,
[ApprovedBy] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateApproved] [date] NULL,
[D2Ktimestamp] [timestamp] NOT NULL,
[AuthorisationStatus] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
