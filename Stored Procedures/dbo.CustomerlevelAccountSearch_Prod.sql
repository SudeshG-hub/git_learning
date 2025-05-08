SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROC [dbo].[CustomerlevelAccountSearch_Prod]
	--declare		
				@CustomerID varchar(30)='62'

AS
	BEGIN
declare @Timekey int
SET @Timekey =(Select TimeKey from SysDataMatrix where CurrentStatus='C') 

  SET @Timekey =(Select LastMonthDateKey from SysDayMatrix where Timekey=@Timekey) 

select A.CustomerACID as AccountId
	  ,A.FacilityType
	  ,null as Segment
	  ,A.Balance as BalancaOutstanding
	  --,D.POS as POS
	  ,A.unserviedint
	  ,A.TotalProvision as NPAProvision
 from  
 pro.AccountCal_Hist A
 --ON A.AccountEntityId=D.AccountEntityId
 --AND A.EffectiveFromTimeKey<=@Timekey
--AND A.EffectiveToTimeKey>=@Timekey
--inner join AdvAcBalanceDetail B
--ON A.AccountEntityId=B.AccountEntityId
--AND B.EffectiveFromTimeKey<=@Timekey
--AND B.EffectiveToTimeKey>=@Timekey
inner join pro.customercal_Hist C
ON C.CustomerEntityId=A.CustomerEntityId
Where A.EffectiveFromTimeKey<=@Timekey
AND A.EffectiveToTimeKey>=@Timekey
and C.EffectiveFromTimeKey<=@Timekey
AND C.EffectiveToTimeKey>=@Timekey
AND C.RefCustomerID=@CustomerID

END
GO
