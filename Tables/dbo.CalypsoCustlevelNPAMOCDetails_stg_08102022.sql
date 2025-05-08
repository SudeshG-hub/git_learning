CREATE TABLE [dbo].[CalypsoCustlevelNPAMOCDetails_stg_08102022]
(
[SlNo] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomerID] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AssetClass] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NPIDate] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SecurityValue] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AdditionalProvision] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MOCSource] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MOCType] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MOCReason] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SourceSystem] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[filname] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Entity_Key] [int] NOT NULL IDENTITY(1, 1),
[SourceAlt_Key] [tinyint] NULL
) ON [PRIMARY]
GO
