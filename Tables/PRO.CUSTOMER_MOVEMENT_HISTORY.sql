CREATE TABLE [PRO].[CUSTOMER_MOVEMENT_HISTORY]
(
[EntityKey] [bigint] NOT NULL IDENTITY(1, 1),
[UCIF_ID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RefCustomerID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SourceSystemCustomerID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomerName] [varchar] (225) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SysAssetClassAlt_Key] [int] NULL,
[SysNPA_Dt] [date] NULL,
[EffectiveFromTimeKey] [int] NULL,
[EffectiveToTimeKey] [int] NULL,
[MovementFromDate] [date] NULL,
[MovementFromStatus] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MovementToStatus] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MovementToDate] [date] NULL,
[TotOsCust] [decimal] (18, 2) NULL
) ON [PRIMARY]
GO
