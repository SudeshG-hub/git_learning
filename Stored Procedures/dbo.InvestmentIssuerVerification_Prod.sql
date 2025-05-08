SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

--exec [InvestmentIssuerVerification] '5555' 
CREATE procedure [dbo].[InvestmentIssuerVerification_Prod]

@IssuerId varchar(30)=''

AS
BEGIN

SET NOCOUNT ON;
Declare @TimeKey as Int
	SET @Timekey =(Select Timekey from SysDataMatrix where CurrentStatus='C')

			IF NOT EXISTS(SELECT 1 FROM [CurDat].[InvestmentIssuerDetail] A WHERE (A.EffectiveFromTimeKey<=@TimeKey AND A.EffectiveToTimeKey>=@TimeKey)  
								AND A.IssuerId=@IssuerId AND ISNULL(A.AuthorisationStatus, 'A') = 'A')
												 BEGIN
												SELECT * into #temp1
												FROM [CurDat].[InvestmentIssuerDetail] A 
												WHERE (A.EffectiveFromTimeKey<=@TimeKey AND A.EffectiveToTimeKey>=@TimeKey)  
												AND A.IssuerId=@IssuerId 
												AND ISNULL(A.AuthorisationStatus, 'A') = 'A'

												SELECT 
												(SELECT ROW_NUMBER() OVER(ORDER BY IssuerEntityID) AS RowNumber), 
														COUNT(*) OVER() AS TotalCount, 
														'InvestmentCodeMaster' TableName, 
														*
												FROM #temp1
												 END
												
												ELSE
												BEGIN
												SELECT * into #temp
												FROM [CurDat].[InvestmentIssuerDetail] A 
												WHERE (A.EffectiveFromTimeKey<=@TimeKey AND A.EffectiveToTimeKey>=@TimeKey)  
												AND A.IssuerId=@IssuerId 
												AND ISNULL(A.AuthorisationStatus, 'A') = 'A'

												SELECT 
												(SELECT ROW_NUMBER() OVER(ORDER BY IssuerEntityID) AS RowNumber), 
														COUNT(*) OVER() AS TotalCount, 
														'InvestmentCodeMaster' TableName, 
														*
												FROM #temp

												 END

												 END

												 
GO
