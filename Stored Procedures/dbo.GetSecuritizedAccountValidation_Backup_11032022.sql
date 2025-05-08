SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[GetSecuritizedAccountValidation_Backup_11032022]
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
		--			,PoolID
		--			,PoolName
		--			,POS
		--			,InterestReceivable
		--			,(Select top(1) POS from SecuritizedSummary S
		--			where S.PoolId=A.PoolId and S.EffectiveFromTimeKey<=@Timekey and S.EffectiveToTimeKey>=@Timekey) as BalanceOS
		--			,'CustSecuritizedFlaggingDetails'as TableName
		--from		SecuritizedACFlaggingDetail A
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
					,PoolID
					,PoolName
					,POS
					,InterestReceivable
					,(Select top(1) POS from SecuritizedSummary_Mod S
					where S.PoolId=A.PoolId and S.EffectiveFromTimeKey<=@Timekey and S.EffectiveToTimeKey>=@Timekey) as BalanceOS
					--,A.ExposureAmount
					--,A.AccountBalance
					,'CustSecuritizedFlaggingDetails'as TableName
		from		SecuritizedACFlaggingDetail_Mod A
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

	--   UNION
	----If(@Flag=2)
	----BEGIN
	--	Select * from (
	--	Select	A.AccountID as CustomerACID
	--				,A.[CustomerId]
	--			    ,B.[CustomerName]
	--				,ACC.SourceAlt_Key
	--				,ds.SourceName
	--				,PoolID
	--				,PoolName
	--				,POS
	--				,InterestReceivable
	--				,(Select top(1) POS from SecuritizedSummary S
	--				where S.PoolId=A.PoolId and S.EffectiveFromTimeKey<=@Timekey and S.EffectiveToTimeKey>=@Timekey) as BalanceOS
	--				,'CustSecuritizedDetails'as TableName
	--	from		SecuritizedDetail A
	--	left join [CurDat].[AdvAcBasicDetail] ACC on ACC.CustomerACID=A.AccountID
	--	and			ACC.EffectiveFromTimeKey<=@Timekey
	--	and			ACC.EffectiveToTimeKey>=@Timekey
	--	left Join	[CurDat].[CustomerBasicDetail] B On ACC.[CustomerEntityId]=B.[CustomerEntityId]
	--	and			B.EffectiveFromTimeKey<=@Timekey
	--	and			B.EffectiveToTimeKey>=@Timekey	
	--	Inner join DIMSOURCEDB ds on ds.SourceAlt_Key=ACC.SourceAlt_Key
	--	where		[CustomerACID] = @CustomerACID
	--	and			A.EffectiveFromTimeKey<=@Timekey
	--	and			A.EffectiveToTimeKey>=@Timekey
	--	And IsNull(A.AuthorisationStatus,'A')='A'
		UNION

		Select	ACC.[CustomerACID]
					,A.[CustomerId]
				    ,[CustomerName]
					,ACC.SourceAlt_Key
					,ds.SourceName
					,PoolID
					,PoolName
					,POS
					,InterestReceivable
					,(Select top(1) POS from SecuritizedSummary_Mod S
					where S.PoolId=A.PoolId and S.EffectiveFromTimeKey<=@Timekey and S.EffectiveToTimeKey>=@Timekey) as BalanceOS
					
					,'CustSecuritizedDetails'as TableName
		from		SecuritizedDetail_MOD A
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

	  --UNION
	--IF(@Flag=3)
	--BEGIN
		Select	[CustomerACID]
					,[CustomerId]
				    ,[CustomerName]
					,A.SourceAlt_Key
					,ds.SourceName
					,' ' 
					,' '
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
		and			B.EffectiveToTimeKey>=@Timekey --)dt
	--END


	
		Select	A.AccountID as CustomerACID
					,A.[CustomerId]
				    ,B.[CustomerName]
					,ACC.SourceAlt_Key
					,ds.SourceName
					,PoolID
					,PoolName
					,POS
					,InterestReceivable
					,(Select top(1) POS from SecuritizedSummary S
					where S.PoolId=A.PoolId and S.EffectiveFromTimeKey<=@Timekey and S.EffectiveToTimeKey>=@Timekey) as BalanceOS
					,A.ExposureAmount
					,A.AccountBalance
					,'CustSecuritizedFinalACDetail'as TableName
		from		SecuritizedFinalACDetail A
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
