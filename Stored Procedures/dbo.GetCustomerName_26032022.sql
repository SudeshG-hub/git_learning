SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[GetCustomerName_26032022]
@CustomerID INT  
AS
BEGIN
Select CustomerId,CustomerName from CustomerBasicDetail where CustomerId= '82000101'
END
GO
