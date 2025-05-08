CREATE TABLE [dbo].[StockStatement_stg_27042022]
(
[Entity_Key] [int] NOT NULL IDENTITY(1, 1),
[SrNo] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CIF] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomerLimitSuffix] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[StockStatementDate] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[filname] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
