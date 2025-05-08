CREATE TABLE [dbo].[EROSION_DATA_3009221]
(
[CustomerEntityID] [int] NOT NULL,
[Customername] [varchar] (225) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RefCustomerID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CurntQtrRv] [decimal] (18, 2) NULL,
[PrvQtrRV] [decimal] (18, 2) NULL,
[ASSETCLASS] [smallint] NULL,
[LossDt] [date] NULL,
[DbtDt] [date] NULL,
[FlgErosion] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ErosionDt] [date] NULL
) ON [PRIMARY]
GO
