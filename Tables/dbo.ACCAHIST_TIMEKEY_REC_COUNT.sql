CREATE TABLE [dbo].[ACCAHIST_TIMEKEY_REC_COUNT]
(
[date] [date] NULL,
[TimeKey] [int] NOT NULL,
[Balance] [decimal] (38, 2) NULL,
[NoofAcs_Current] [int] NULL,
[Balance_Opt] [decimal] (16, 2) NULL,
[NoofAcs_Opt] [bigint] NULL,
[Balance_Diff] [decimal] (16, 2) NULL,
[NoofAcs_Diff] [bigint] NULL
) ON [PRIMARY]
GO
