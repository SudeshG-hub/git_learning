CREATE TABLE [dbo].[ReverseFeed_ENPA_Detail]
(
[SrNo] [int] NULL,
[ATHEZ-D-ORG] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ATHEZ-D-ACCT-NBR] [varchar] (19) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ATHEZ-D-CARD-SEQ-NBR] [varchar] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ATHEZ-D-FILE-CODE] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ATHEZ-D-FIELD-CODE] [varchar] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ATHEZ-D-FIELD-OCCURRENCE] [varchar] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ATHEZ-D-FIELD-LENGTH] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ATHEZ-D-BEFORE-DATA] [varchar] (60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ATHEZ-D-AFTER-DATA] [varchar] (60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ATHEZ-D-SIGNON] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FILLER] [varchar] (11) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ATHEZ-D-PLAN-NBR] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ATHEZ-D-REC-NBR] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ATHEZ-D-REC-TYPE-KEY] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateofData] [date] NULL,
[EffectiveFromTimeKey] [int] NULL,
[EffectiveToTimeKey] [int] NULL
) ON [PRIMARY]
GO
