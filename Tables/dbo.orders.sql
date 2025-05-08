CREATE TABLE [dbo].[orders]
(
[order_id] [int] NOT NULL,
[order_date] [date] NULL,
[customer_name] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[product_name] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[total_amount] [decimal] (10, 2) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[orders] ADD CONSTRAINT [PK__orders__46596229E1AB694C] PRIMARY KEY CLUSTERED ([order_id]) ON [PRIMARY]
GO
