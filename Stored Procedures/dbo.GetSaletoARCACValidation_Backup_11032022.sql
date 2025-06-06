SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[GetSaletoARCACValidation_Backup_11032022]
@CustomerACID  varchar (50)
--,@Flag Int
AS
	BEGIN

Declare @Timekey Int
Set @Timekey =(Select TimeKey from SysDataMatrix where CurrentStatus='C')

--Set @Timekey =(Select TimeKey from SysDayMatrix where Date=Cast(Getdate() as Date))
BEGIN

--IF(@Flag=1)
	--BEGIN
		select * from
		--(Select	A.AccountID as CustomerACID
		--			,A.[CustomerId]
		--		    ,B.[CustomerName]
		--			,ACC.SourceAlt_Key
		--			,ds.SourceName
		--			,' ' AS PoolID
		--			,' ' AS PoolName
		--			,POS
		--			,InterestReceivable
		--			,(Select top(1) BalanceOutstanding from SaletoARC S
		--			where S.CustomerID=A.CustomerID and S.EffectiveFromTimeKey<=@Timekey and S.EffectiveToTimeKey>=@Timekey) as BalanceOS
		--			,ExposureAmount
		--			,'CustSaletoARCFlaggingDetails'as TableName
		--from		SaletoARCACFlaggingDetail A
		--left join [CurDat].[AdvAcBasicDetail] ACC on ACC.CustomerACID=A.AccountID
		--and			ACC.EffectiveFromTimeKey<=@Timekey
		--and			ACC.EffectiveToTimeKey>=@Timekey
		--left Join	[CurDat].[CustomerBasicDetail] B On ACC.[CustomerEntityId]=B.[CustomerEntityId]
		--and			B.EffectiveFromTimeKey<=@Timekey
		--and			B.EffectiveToTimeKey>=@Timekey	
		--Inner join DIMSOURCEDB ds on ds.SourceAlt_Key=ACC.SourceAlt_Key
		--where		[CustomerACID] = @CustomerACID
		--and			A.EffectiveFromTimeKey<=@Timekey
		--and			A.EffectiveToTimeKey>=@Timekey
		--And IsNull(A.AuthorisationStatus,'A')='A'

		--UNION

		(Select	ACC.[CustomerACID]
					,A.[CustomerId]
				    ,B.[CustomerName]
					,ACC.SourceAlt_Key
					,ds.SourceName
					,' ' AS PoolID
					,' ' AS PoolName
					,POS
					,InterestReceivable
					,(Select top(1) BalanceOutstanding from SaletoARC_Mod S
					where S.CustomerID=A.CustomerID and S.EffectiveFromTimeKey<=@Timekey and S.EffectiveToTimeKey>=@Timekey) as BalanceOS
					,ExposureAmount
					,'CustSaletoARCFlaggingDetails'as TableName
		from		SaletoARCACFlaggingDetail_Mod A
		Inner join [CurDat].[AdvAcBasicDetail] ACC on ACC.CustomerACID=A.AccountID
		and			ACC.EffectiveFromTimeKey<=@Timekey
		and			ACC.EffectiveToTimeKey>=@Timekey
		Inner Join	[CurDat].[CustomerBasicDetail] B On ACC.[CustomerEntityId]=B.[CustomerEntityId]
		and			B.EffectiveFromTimeKey<=@Timekey
		and			B.EffectiveToTimeKey>=@Timekey	
		Inner join DIMSOURCEDB ds on ds.SourceAlt_Key=ACC.SourceAlt_Key
		where		[CustomerACID] = @CustomerACID
		and			A.EffectiveFromTimeKey<=@Timekey
		and			A.EffectiveToTimeKey>=@Timekey
		And IsNull(A.AuthorisationStatus,'A') in('NP','MP','1A')--)dt
	--END
	  UNION

	--If(@Flag=2)
	--BEGIN
		--Select * from (
		--Select	A.AccountID as CustomerACID
		--			,A.[CustomerId]
		--		    ,B.[CustomerName]
		--			,ACC.SourceAlt_Key
		--			,ds.SourceName
		--			,PoolID
		--			,PoolName
		--			,POS
		--			,InterestReceivable
		--			,BalanceOutstanding
		--			,0 AS ExposureAmount
		--			--,(Select top(1) BalanceOutstanding from IBPCPoolSummary S
		--			--where S.PoolId=A.PoolId and S.EffectiveFromTimeKey<=@Timekey and S.EffectiveToTimeKey>=@Timekey) as BalanceOS
		--			,'CustSaletoARCDetails'as TableName
		--from		SaletoARC A
		--left join [CurDat].[AdvAcBasicDetail] ACC on ACC.CustomerACID=A.AccountID
		--and			ACC.EffectiveFromTimeKey<=@Timekey
		--and			ACC.EffectiveToTimeKey>=@Timekey
		--left Join	[CurDat].[CustomerBasicDetail] B On ACC.[CustomerEntityId]=B.[CustomerEntityId]
		--and			B.EffectiveFromTimeKey<=@Timekey
		--and			B.EffectiveToTimeKey>=@Timekey	
		--Inner join DIMSOURCEDB ds on ds.SourceAlt_Key=ACC.SourceAlt_Key
		--where		[CustomerACID] = @CustomerACID
		--and			A.EffectiveFromTimeKey<=@Timekey
		--and			A.EffectiveToTimeKey>=@Timekey
		--And IsNull(A.AuthorisationStatus,'A')='A'
		--UNION

		Select	ACC.[CustomerACID]
					,A.[CustomerId]
				    ,A.[CustomerName]
					,ACC.SourceAlt_Key
					,ds.SourceName
					,PoolID
					,PoolName
					,POS
					,InterestReceivable
					,BalanceOutstanding
					,0 AS ExposureAmount
					--,(Select top(1) BalanceOutstanding from IBPCPoolSummary_Mod S
					--where S.PoolId=A.PoolId and S.EffectiveFromTimeKey<=@Timekey and S.EffectiveToTimeKey>=@Timekey) as BalanceOS
					,'CustSaletoARCDetails'as TableName
		from		SaletoARC_Mod A
		Inner join [CurDat].[AdvAcBasicDetail] ACC on ACC.CustomerACID=A.AccountID
		and			ACC.EffectiveFromTimeKey<=@Timekey
		and			ACC.EffectiveToTimeKey>=@Timekey
		Inner Join	[CurDat].[CustomerBasicDetail] B On ACC.[CustomerEntityId]=B.[CustomerEntityId]
		and			B.EffectiveFromTimeKey<=@Timekey
		and			B.EffectiveToTimeKey>=@Timekey	
		Inner join DIMSOURCEDB ds on ds.SourceAlt_Key=ACC.SourceAlt_Key
		where		[CustomerACID] = @CustomerACID
		and			A.EffectiveFromTimeKey<=@Timekey
		and			A.EffectiveToTimeKey>=@Timekey
		And IsNull(A.AuthorisationStatus,'A') in('NP','MP','1A'))dt
	--END
	 -- UNION

	--IF(@Flag=3)
	--BEGIN
		Select	[CustomerACID]
					,[CustomerId]
				    ,[CustomerName]
					,A.SourceAlt_Key
					,ds.SourceName
					,' ' AS PoolID
					,' ' AS PoolName
					,0
					,0
					,0
					,0
					,'CustDetails'as TableName
		from		[CurDat].[AdvAcBasicDetail] A
		Inner Join	[CurDat].[CustomerBasicDetail] B On A.[CustomerEntityId]=B.[CustomerEntityId]	
		Inner join DIMSOURCEDB ds on ds.SourceAlt_Key=A.SourceAlt_Key
		where		[CustomerACID] = @CustomerACID
		and			A.EffectiveFromTimeKey<=@Timekey
		and			A.EffectiveToTimeKey>=@Timekey
		and			B.EffectiveFromTimeKey<=@Timekey
		and			B.EffectiveToTimeKey>=@Timekey--)dt
	--END

	Select	A.AccountID as CustomerACID
					,A.[CustomerId]
				    ,B.[CustomerName]
					,ACC.SourceAlt_Key
					,ds.SourceName
					,' ' AS PoolID
					,' ' AS PoolName
					,POS
					,InterestReceivable
					,(Select top(1) BalanceOutstanding from SaletoARC S
					where S.CustomerID=A.CustomerID and S.EffectiveFromTimeKey<=@Timekey and S.EffectiveToTimeKey>=@Timekey) as BalanceOS
					,ExposureAmount
					,A.AccountBalance
					,'CustSaletoARCFinalACFlagging'as TableName
		from		SaletoARCFinalACFlagging A
		left join [CurDat].[AdvAcBasicDetail] ACC on ACC.CustomerACID=A.AccountID
		and			ACC.EffectiveFromTimeKey<=@Timekey
		and			ACC.EffectiveToTimeKey>=@Timekey
		left Join	[CurDat].[CustomerBasicDetail] B On ACC.[CustomerEntityId]=B.[CustomerEntityId]
		and			B.EffectiveFromTimeKey<=@Timekey
		and			B.EffectiveToTimeKey>=@Timekey	
		Inner join DIMSOURCEDB ds on ds.SourceAlt_Key=ACC.SourceAlt_Key
		where		[CustomerACID] = @CustomerACID
		and			A.EffectiveFromTimeKey<=@Timekey
		and			A.EffectiveToTimeKey>=@Timekey
		And IsNull(A.AuthorisationStatus,'A')='A'


END				

	END
GO
