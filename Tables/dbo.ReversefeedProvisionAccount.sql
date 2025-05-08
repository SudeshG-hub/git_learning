CREATE TABLE [dbo].[ReversefeedProvisionAccount]
(
[DateofData] [date] NULL,
[SOURCE_SYSTEM] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CIF_ID] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FORACID] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SOL_ID] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TOT_PROVISION] [decimal] (16, 2) NOT NULL,
[TOTAL_PROV_PREV] [decimal] (16, 2) NOT NULL,
[INCR_TOTAL_PROV] [decimal] (17, 2) NULL,
[DECR_TOTAL_PROV] [decimal] (17, 2) NULL
) ON [PRIMARY]
GO
