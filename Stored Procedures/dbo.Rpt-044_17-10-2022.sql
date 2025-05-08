SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/*
CREATED BY  :-Baijayanti
CREATED DATE :-12/08/2022
REPORT NAME  :-Buyout Report As On
*/


CREATE PROCEDURE [dbo].[Rpt-044_17-10-2022]
      @TimeKey AS INT
AS

--DECLARE 
--      @TimeKey AS INT=26372


SELECT 

AUNo
,BuyoutPartyLoanNo
,CustomerName
,PAN
,AadharNo
,DPD
,ISNULL(InterestReceivable,0)              AS InterestReceivable
,ISNULL(PrincipalOutstanding,0)            AS PrincipalOutstanding
,PoolName
,Category
,ISNULL(Charges,0)                         AS Charges
,ISNULL(AccuredInterest,0)				   AS AccuredInterest
,[Action]
,Remark

FROM BuyoutFinalDetails 

WHERE   EffectiveFromTimeKey<=@TimeKey AND EffectiveToTimeKey>=@TimeKey

OPTION(RECOMPILE)
GO
