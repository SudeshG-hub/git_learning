CREATE TABLE [dbo].[orders1]
(
[order_id] [int] NOT NULL,
[order_date] [date] NULL,
[customer_name] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[product_name] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[total_amount] [decimal] (10, 2) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[orders1] ADD CONSTRAINT [PK__orders1__46596229F0F16167] PRIMARY KEY CLUSTERED ([order_id]) ON [PRIMARY]
GO
