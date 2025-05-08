SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GetSudeshOrders]
AS
BEGIN
    DECLARE @CustomerName VARCHAR(100) = 'Sudesh';
    DECLARE @StartDate DATE = DATEADD(MONTH, -3, GETDATE()); 
    DECLARE @EndDate DATE = GETDATE();

    SELECT order_id, order_date, customer_name, product_name, total_amount
    FROM orders1
    WHERE customer_name = @CustomerName
        AND order_date BETWEEN @StartDate AND @EndDate
    ORDER BY order_date;
END;
GO
