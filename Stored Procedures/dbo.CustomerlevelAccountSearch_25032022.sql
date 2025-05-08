SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[CustomerlevelAccountSearch_25032022]
	--declare		
				@CustomerID varchar(30)='82000361'

AS
	BEGIN
declare @Timekey int

SET @Timekey =(Select Timekey from SysDataMatrix Where MOC_Initialised='Y' AND ISNULL(MOC_Frozen,'N')='N') 

select A.CustomerACID as AccountId
	  ,A.FacilityType
	  ,null as Segment
	  ,C.Balance as BalancaOutstanding
	  --,D.POS as POS
	  --,A.unserviedint
	  ,C.InterestReceivable   unserviedint
	  --,A.TotalProvision as NPAProvision
	  ,C.TotalProv NPAProvision
 from  
 curdat.AdvAcBasicDetail A
LEFT JOIN curdat.AdvAcBalanceDetail C
ON   A.RefCustomerId=C.RefCustomerId
AND C.EffectiveFromTimeKey<=@Timekey
AND C.EffectiveToTimeKey>=@Timekey
Where A.EffectiveFromTimeKey<=@Timekey
AND A.EffectiveToTimeKey>=@Timekey
AND A.RefCustomerID=@CustomerID

END
GO
