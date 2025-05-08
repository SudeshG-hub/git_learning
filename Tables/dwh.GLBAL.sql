CREATE TABLE [dwh].[GLBAL]
(
[dt] [datetime] NULL,
[GL_SUB_HEAD_CODE] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[sol_id] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[d_amt] [decimal] (18, 2) NULL,
[c_amt] [decimal] (18, 2) NULL,
[GL_SUB_HEAD_DESC] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
