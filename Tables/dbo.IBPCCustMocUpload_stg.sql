CREATE TABLE [dbo].[IBPCCustMocUpload_stg]
(
[SrNo] [int] NULL,
[UploadID] [int] NULL,
[SummaryID] [int] NULL,
[Sl.No.] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Customer ID] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Asset Class] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NPA Date] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Security Value] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Additional Provision %] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MOC Source] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MOC Type] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MOC Reason] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
