CREATE TABLE [dbo].[AdhocACL_ChangeDetails_Mod]
(
[UCIF_ID] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UcifEntityID] [int] NULL,
[CustomerId] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomerEntityId] [int] NULL,
[PrevAssetClassAlt_Key] [smallint] NULL,
[PrevNPA_Date] [date] NULL,
[AssetClassAlt_Key] [smallint] NULL,
[NPA_Date] [date] NULL,
[Remark] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AuthorisationStatus] [char] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EffectiveFromTimeKey] [int] NULL,
[EffectiveToTimeKey] [int] NULL,
[DateCreated] [smalldatetime] NULL,
[CreatedBy] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateModified] [smalldatetime] NULL,
[ModifyBy] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateApproved] [smalldatetime] NULL,
[ApprovedBy] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[D2Ktimestamp] [timestamp] NULL,
[ChangeFields] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Reason] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FirstLevelDateApproved] [smalldatetime] NULL,
[FirstLevelApprovedBy] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomerName] [varchar] (225) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ChangeType] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EntityKey] [bigint] NOT NULL IDENTITY(1, 1)
) ON [PRIMARY]
GO
