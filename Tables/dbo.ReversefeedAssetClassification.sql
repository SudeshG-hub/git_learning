CREATE TABLE [dbo].[ReversefeedAssetClassification]
(
[DATE_OF_DATA] [date] NULL,
[SOURCE_SYSTEM] [varchar] (7) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CIF_ID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FORACID] [varchar] (16) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SOL_ID] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CURR_ASST_MAIN_CLS] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CURR_ASST_SUB_CLS] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[REV_ASST_MAIN_CLS] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[REV_ASST_SUB_CLS] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NPA_DATE] [date] NULL,
[DPD] [int] NULL,
[FREE_TEXT_1] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FREE_TEXT_2] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FREE_TEXT_3] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BANK_ID] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
