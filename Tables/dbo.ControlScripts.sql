CREATE TABLE [dbo].[ControlScripts]
(
[EntityKey] [int] NOT NULL IDENTITY(1, 1),
[UCIF_ID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PANNO] [varchar] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomerAcID] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RefCustomerID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SourceSystemCustomerID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomerName] [varchar] (225) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SourceName] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DPD_Max] [int] NULL,
[POS] [decimal] (16, 2) NULL,
[BalanceInCrncy] [decimal] (16, 2) NULL,
[Balance] [decimal] (16, 2) NULL,
[SysNPA_Dt] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FinalAssetClassName] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ExceptionCode] [smallint] NULL,
[ExceptionDescription] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DPDPreviousDay] [int] NULL,
[DPDCurrentDay] [int] NULL,
[EffectiveFromTimeKey] [int] NULL,
[EffectiveToTimeKey] [int] NULL
) ON [PRIMARY]
GO
