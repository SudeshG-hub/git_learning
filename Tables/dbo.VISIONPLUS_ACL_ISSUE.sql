CREATE TABLE [dbo].[VISIONPLUS_ACL_ISSUE]
(
[UCIC Code] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CIF ID] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Customer Name] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SOL ID] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SOL Name] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Location] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Region] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Account no] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CNPA Status Sys] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CNPA System Sub Status] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Host Main Classification] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Host Sub Classification] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CNPA Staus] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DPD Account] [float] NULL,
[Base System name] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NPA From Date ] [datetime] NULL,
[Outstanding Balance] [float] NULL,
[Audit Remarks] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ACL] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NPA Report Date] [datetime] NULL,
[AccountEntityId] [int] NULL
) ON [PRIMARY]
GO
