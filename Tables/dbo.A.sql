CREATE TABLE [dbo].[A]
(
[Date of Data] [date] NULL,
[Source System] [varchar] (7) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ISSUER_ID] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CIF ID] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ISSUER_NAME] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[InvID] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ISIN] [varchar] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NPI_DATE] [date] NULL,
[NPI_CLASSIFICATION] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ACC_DATE] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ACC_AMOUNT] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MTM Income Amount] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Overdue Coupon Amount] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
