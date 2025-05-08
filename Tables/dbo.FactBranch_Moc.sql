CREATE TABLE [dbo].[FactBranch_Moc]
(
[BranchCode] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TimeKey] [smallint] NULL,
[UnderAudit] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BO_MOC_Frozen] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BO_MOC_FreezingDate] [smalldatetime] NULL,
[BO_MOC_FreezingBy] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RO_MOC_Frozen] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RO_MOC_FreezingDate] [smalldatetime] NULL,
[RO_MOC_FreezingBy] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ZO_MOC_Frozen] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ZO_MOC_FreezingDate] [smalldatetime] NULL,
[ZO_MOC_FreezingBy] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
