SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[GetCustomerName]
@CustomerID INT  
AS
BEGIN
Select CustomerId,CustomerName from CustomerBasicDetail where CustomerId=@CustomerID
END

GO
