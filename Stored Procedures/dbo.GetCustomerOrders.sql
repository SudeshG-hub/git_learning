SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GetCustomerOrders]
    @CustomerName VARCHAR(100),
    @TimePeriod INT
AS
BEGIN
    DECLARE @StartDate DATE;
    DECLARE @EndDate DATE;

  
    SET @EndDate = GETDATE();  
    SET @StartDate = DATEADD(MONTH, -@TimePeriod, @EndDate);  

    
    SELECT order_id, order_date, customer_name, product_name, total_amount
    FROM orders3
    WHERE customer_name = @CustomerName
        AND order_date BETWEEN @StartDate AND @EndDate
    ORDER BY order_date;
END;

GO
