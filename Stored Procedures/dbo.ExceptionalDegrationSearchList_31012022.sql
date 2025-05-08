SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- exec ExceptionalDegrationSearchList @AccountID=9987880000000003,@operationFlag=1

--exec ExceptionalDegrationSearchList @AccountID=NULL,@operationFlag=16
--go
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Create PROC [dbo].[ExceptionalDegrationSearchList_31012022]

	--declare												
													--@PageNo         INT         = 1, 
													--@PageSize       INT         = 10, 
													@OperationFlag  INT         = 20
												   ,@AccountID varchar(30)=NULL--'9987880000000003'
												   --9987880000000003
AS
     
	 BEGIN

SET NOCOUNT ON;
Declare @TimeKey as Int
	SET @Timekey =(Select Timekey from SysDataMatrix where CurrentStatus='C')
					

BEGIN TRY




IF OBJECT_ID('TempDB..#Reminder') IS NOT NULL
Drop Table #Reminder

Select *
into #Reminder from
(
Select FlagAlt_Key,AccountID

from [dbo].[ExceptionalDegrationDetail]
where EffectiveFromTimeKey <= @TimeKey
 AND EffectiveToTimeKey >= @TimeKey
  And ISNULL(AuthorisationStatus,'A')  ='A'                          
union 

Select FlagAlt_Key,AccountID

from [dbo].[ExceptionalDegrationDetail_mod]
where EffectiveFromTimeKey <= @TimeKey
 AND EffectiveToTimeKey >= @TimeKey
  And ISNULL(AuthorisationStatus,'A') in ('NP' ,'MP','1A')  
)
A
--Select * from #Reminder

IF OBJECT_ID('TempDB..#ReminderReport') IS NOT NULL
Drop Table #ReminderReport

Create Table #ReminderReport( AccountID varchar(30),FlagAlt_Key Int )

Insert Into #ReminderReport(FlagAlt_Key,AccountID)


Select A.Businesscolvalues1 as FlagAlt_Key,A.AccountID From (
SELECT AccountID,Split.a.value('.', 'VARCHAR(8000)') AS Businesscolvalues1  
                            FROM  (SELECT 
                                            CAST ('<M>' + REPLACE(FlagAlt_Key, ',', '</M><M>') + '</M>' AS XML) AS Businesscolvalues1,
                                                                                        AccountID
                                            from #Reminder
                                    ) AS A CROSS APPLY Businesscolvalues1.nodes ('/M') AS Split(a)
                                                 
)A Where A.Businesscolvalues1<>''

--Select * from #ReminderReport1

IF OBJECT_ID('TempDB..#ReminderReport1') IS NOT NULL
Drop Table #ReminderReport1


Select A.*,B.ParameterName as FlagName Into #ReminderReport1  from #ReminderReport A
Inner Join DimParameter B ON A.FlagAlt_Key=B.parameterAlt_Key
Where B.[DimParameterName]='UploadFLagType'



--IF OBJECT_ID('TempDB..#Secondary') IS NOT NULL
--Drop Table #Secondary

--Select * Into #Secondary From (
--Select A.AccountID,A.REPORTIDSLIST as FlagName From (
--SELECT SS.AccountID,
--                STUFF((SELECT ',' + US.FlagName 
--                        FROM #ReminderReport1 US
--                        WHERE US.AccountID = SS.AccountID 
--                        FOR XML PATH('')), 1, 1, '') [REPORTIDSLIST]
--                FROM #ReminderReport1 SS 
--                GROUP BY SS.AccountID
--                )A
--        )A


/*  IT IS Used FOR GRID Search which are not Pending for Authorization And also used for Re-Edit    */

			IF(@OperationFlag not in ( 16,17,20))
             BEGIN
			 IF OBJECT_ID('TempDB..#temp') IS NOT NULL
                 DROP TABLE  #temp;
                 SELECT		A.DegrationAlt_Key,
							A.SourceName,
							A.SourceAlt_Key,
							A.AccountID,
							A.RefCustomerId AS CustomerID,
							A.FlagAlt_Key,
							A.FlagName,
							A.Date,
							A.Marking,
							A.MarkingAlt_Key,
							Amount,
							A.AuthorisationStatus, 
                            A.EffectiveFromTimeKey, 
                            A.EffectiveToTimeKey, 
                            A.CreatedBy, 
                            A.DateCreated, 
                            A.ApprovedBy, 
                            A.DateApproved, 
                            A.ModifiedBy, 
                            A.DateModified,
							A.CrModBy,
							A.CrModDate,
							A.CrAppBy,
							A.CrAppDate,
							A.ModAppBy,
							A.ModAppDate
                 INTO #temp
                 FROM 
                 (
                     SELECT 
							A.DegrationAlt_Key,
							B.SourceName,
							C.SourceAlt_Key,
							A.AccountID,
							C.RefCustomerId,
							A.FlagAlt_Key,
							S.FlagName,
							Convert(Varchar(20),A.Date,103) Date,
							H.ParameterName as Marking,
							A.MarkingAlt_Key,
							Amount,
							isnull(A.AuthorisationStatus, 'A') as AuthorisationStatus, 
                            A.EffectiveFromTimeKey, 
                            A.EffectiveToTimeKey, 
                            A.CreatedBy, 
                            Convert(Varchar(20),A.DateCreated,103) DateCreated, 
                            A.ApprovedBy, 
                            Convert(Varchar(20),A.DateApproved,103) DateApproved, 
                            A.ModifiedBy, 
                            Convert(Varchar(20),A.DateModified,103) DateModified,
							IsNull(A.ModifiedBy,A.CreatedBy)as CrModBy

							,IsNull(A.DateModified,A.DateCreated)as CrModDate
							,ISNULL(A.ApprovedBy,A.CreatedBy) as CrAppBy
							,ISNULL(A.DateApproved,A.DateCreated) as CrAppDate
							,ISNULL(A.ApprovedBy,A.ModifiedBy) as ModAppBy
							,ISNULL(A.DateApproved,A.DateModified) as ModAppDate

                     FROM		[dbo].[ExceptionalDegrationDetail] A
					 Inner JOIn #ReminderReport1 S ON S.AccountID=A.AccountID
					 AND A.FlagAlt_Key = S.FlagAlt_Key
					  Inner Join (Select ParameterAlt_Key,ParameterName,'DimYesNo' as Tablename 
						  from DimParameter where DimParameterName='DimYesNo'
						  And EffectiveFromTimeKey<=@TimeKey And EffectiveToTimeKey>=@TimeKey)H
						  ON H.ParameterAlt_Key=A.MarkingAlt_Key
						  inner join dbo.AdvAcBasicDetail C
						  ON A.AccountID=C.CustomerACID
						  AND C.EffectiveFromTimeKey <= @TimeKey AND C.EffectiveToTimeKey >= @TimeKey
						  left join  [dbo].[DIMSOURCEDB] B on C.SourceAlt_Key=B.SourceAlt_Key
					  WHERE  A.EffectiveFromTimeKey <= @TimeKey
                           AND A.EffectiveToTimeKey >= @TimeKey
                           AND ISNULL(A.AuthorisationStatus, 'A') = 'A'
						   AND A.AccountID=@AccountID
                     UNION
                     SELECT A.DegrationAlt_Key,
							B.SourceName,
							C.SourceAlt_Key,
							A.AccountID,
							C.RefCustomerId,
							A.FlagAlt_Key,
							S.FlagName,
							Convert(Varchar(20),A.Date,103) Date,
							H.ParameterName as Marking,
							A.MarkingAlt_Key,
							Amount,
							isnull(A.AuthorisationStatus, 'A') as AuthorisationStatus, 
                            A.EffectiveFromTimeKey, 
                            A.EffectiveToTimeKey, 
                            A.CreatedBy, 
                            Convert(Varchar(20),A.DateCreated,103) DateCreated, 
                            A.ApprovedBy, 
                            Convert(Varchar(20),A.DateApproved,103) DateApproved, 
                            A.ModifiedBy, 
                            Convert(Varchar(20),A.DateModified,103) DateModified,
							IsNull(A.ModifiedBy,A.CreatedBy)as CrModBy

							,IsNull(A.DateModified,A.DateCreated)as CrModDate
							,ISNULL(A.ApprovedBy,A.CreatedBy) as CrAppBy
							,ISNULL(A.DateApproved,A.DateCreated) as CrAppDate
							,ISNULL(A.ApprovedBy,A.ModifiedBy) as ModAppBy
							,ISNULL(A.DateApproved,A.DateModified) as ModAppDate

                     FROM		[dbo].[ExceptionalDegrationDetail_Mod] A
					 Inner JOIn #ReminderReport1 S ON S.AccountID=A.AccountID
					 AND A.FlagAlt_Key = S.FlagAlt_Key
					 Inner Join (Select ParameterAlt_Key,ParameterName,'DimYesNo' as Tablename 
						  from DimParameter where DimParameterName='DimYesNo'
						  And EffectiveFromTimeKey<=@TimeKey And EffectiveToTimeKey>=@TimeKey)H
						  ON H.ParameterAlt_Key=A.MarkingAlt_Key
						  inner join dbo.AdvAcBasicDetail C
						  ON A.AccountID=C.CustomerACID
						  AND C.EffectiveFromTimeKey <= @TimeKey
                           AND C.EffectiveToTimeKey >= @TimeKey
						    left join  [dbo].[DIMSOURCEDB] B on C.SourceAlt_Key=B.SourceAlt_Key
					
					 WHERE A.EffectiveFromTimeKey <= @TimeKey
                           AND A.EffectiveToTimeKey >= @TimeKey
						   AND A.AccountID=@AccountID
                       --AND ISNULL(AuthorisationStatus, 'A') IN('NP', 'MP', 'DP')
                           AND A.Entity_Key IN
                     (
                         SELECT MAX(Entity_Key)
                         FROM [dbo].[ExceptionalDegrationDetail_Mod]
                         WHERE EffectiveFromTimeKey <= @TimeKey
                               AND EffectiveToTimeKey >= @TimeKey
                               AND ISNULL(AuthorisationStatus, 'A') IN('NP', 'MP', 'DP', 'RM','1A')
                         GROUP BY AccountID,FlagAlt_Key
                     )
                 ) A 
                      
                 
                 GROUP BY A.DegrationAlt_Key,
							A.SourceName,
							A.SourceAlt_Key,
							A.AccountID,
							A.RefCustomerId,
							A.FlagAlt_Key,
							A.FlagName,
							A.Date,
							A.Marking,
							A.MarkingAlt_Key,
							Amount,
							A.AuthorisationStatus, 
                            A.EffectiveFromTimeKey, 
                            A.EffectiveToTimeKey, 
                            A.CreatedBy, 
                            A.DateCreated, 
                            A.ApprovedBy, 
                            A.DateApproved, 
                            A.ModifiedBy, 
                            A.DateModified,
							A.crModBy,
							A.CrModDate,
							A.CrAppBy,
							A.CrAppDate,
							A.ModAppBy,
							A.ModAppDate
							;

					

                 SELECT *
                 FROM
                 (
                     SELECT ROW_NUMBER() OVER(ORDER BY DegrationAlt_Key) AS RowNumber, 
                            COUNT(*) OVER() AS TotalCount, 
                            'ExceptionalDegrationDetail' TableName, 
                            *
                     FROM
                     (
                         SELECT *
                         FROM  #temp A
                         --WHERE ISNULL(BankCode, '') LIKE '%'+@BankShortName+'%'
                         --      AND ISNULL(BankName, '') LIKE '%'+@BankName+'%'
                     ) AS DataPointOwner
                 ) AS DataPointOwner
                 --WHERE RowNumber >= ((@PageNo - 1) * @PageSize) + 1
                 --      AND RowNumber <= (@PageNo * @PageSize);
             END;

------------------------------------------------------------------------------
			 IF (@OperationFlag in (1))

			 BEGIN
			  IF NOT EXISTS (select 1 from #temp where AccountID=@AccountID)
			  BEGIN 
			     select C.SourceSystemAlt_Key ,CustomerID,SourceName ,'CustomerSourceDetails' TableName

				 from AdvAcBasicDetail A
				 inner join CustomerBasicDetail C On C.CustomerEntityId=A.CustomerEntityId
				 inner join DIMSOURCEDB  S oN S.SourceAlt_Key=C.SourceSystemAlt_Key
				 where CustomerACID=@AccountID
				AND  A.EffectiveFromTimeKey <= @TimeKey      AND A.EffectiveToTimeKey >= @TimeKey
				AND  C.EffectiveFromTimeKey <= @TimeKey      AND C.EffectiveToTimeKey >= @TimeKey

				 --select * from CustomerBasicDetail
				 --select * from AdvAcBasicDetail
			  END 

			 END
--------------------------------------------------------------------------------------

             ELSE

			 /*  IT IS Used For GRID Search which are Pending for Authorization    */
			 IF (@OperationFlag in (16,17))

             BEGIN
			 IF OBJECT_ID('TempDB..#temp16') IS NOT NULL
                 DROP TABLE #temp16;
                 SELECT A.DegrationAlt_Key,
							A.SourceName,
							A.SourceAlt_Key,
							A.AccountID,
							A.RefCustomerId  AS CustomerID,
							A.FlagAlt_Key,
							A.FlagName,
							A.Date,
							A.Marking,
							A.MarkingAlt_Key,
							Amount,
							A.AuthorisationStatus, 
                            A.EffectiveFromTimeKey, 
                            A.EffectiveToTimeKey, 
                            A.CreatedBy, 
                            A.DateCreated, 
                            A.ApprovedBy, 
                            A.DateApproved, 
                            A.ModifiedBy, 
                            A.DateModified,
							A.CrModBy,
							A.CrModDate,
							A.CrAppBy,
							A.CrAppDate,
							A.ModAppBy,
							A.ModAppDate
                 INTO #temp16
                 FROM 
                 (
                     SELECT A.DegrationAlt_Key,
							B.SourceName,
							C.SourceAlt_Key,
							A.AccountID,
							C.RefCustomerId,
							S.FlagAlt_Key,
							S.FlagName,
							Convert(Varchar(20),A.Date,103) Date,
							H.ParameterName as Marking,
							A.MarkingAlt_Key,
							Amount,
							isnull(A.AuthorisationStatus, 'A') AuthorisationStatus, 
                            A.EffectiveFromTimeKey, 
                            A.EffectiveToTimeKey, 
                            A.CreatedBy, 
                            Convert(Varchar(20),A.DateCreated,103) DateCreated, 
                        A.ApprovedBy, 
                            Convert(Varchar(20),A.DateApproved,103) DateApproved, 
                            A.ModifiedBy, 
                            Convert(Varchar(20),A.DateModified,103) DateModified,
							IsNull(A.ModifiedBy,A.CreatedBy)as CrModBy

							,IsNull(A.DateModified,A.DateCreated)as CrModDate
							,ISNULL(A.ApprovedBy,A.CreatedBy) as CrAppBy
							,ISNULL(A.DateApproved,A.DateCreated) as CrAppDate
							,ISNULL(A.ApprovedBy,A.ModifiedBy) as ModAppBy
							,ISNULL(A.DateApproved,A.DateModified) as ModAppDate

                     FROM ExceptionalDegrationDetail_Mod A
					 Inner JOIn #ReminderReport1 S ON S.AccountID=A.AccountID and S.FlagAlt_Key=A.FlagAlt_Key
					 Inner Join (Select ParameterAlt_Key,ParameterName,'DimYesNo' as Tablename 
						  from DimParameter where DimParameterName='DimYesNo'
						  And EffectiveFromTimeKey<=@TimeKey And EffectiveToTimeKey>=@TimeKey)H
						  ON H.ParameterAlt_Key=A.MarkingAlt_Key
						  left join dbo.AdvAcBasicDetail C
						  ON A.AccountID=C.CustomerACID
						  AND C.EffectiveFromTimeKey <= @TimeKey AND C.EffectiveToTimeKey >= @TimeKey
						  left join  [dbo].[DIMSOURCEDB] B on C.SourceAlt_Key=B.SourceAlt_Key
					 WHERE A.EffectiveFromTimeKey <= @TimeKey
                           AND A.EffectiveToTimeKey >= @TimeKey
						  -- AND A.AccountID=@AccountID
                           --AND ISNULL(AuthorisationStatus, 'A') IN('NP', 'MP', 'DP')
                           AND A.Entity_Key IN
                     (
                         SELECT MAX(Entity_Key)
                         FROM ExceptionalDegrationDetail_Mod
                         WHERE EffectiveFromTimeKey <= @TimeKey
                               AND EffectiveToTimeKey >= @TimeKey
                               AND ISNULL(AuthorisationStatus, 'A') IN('NP', 'MP', 'DP', 'RM')
                         GROUP BY AccountID,FlagAlt_Key
                     )
                 ) A 
                      
                 
                 GROUP BY A.DegrationAlt_Key,
							A.SourceName,
							A.SourceAlt_Key,
							A.AccountID,
							A.RefCustomerID,
							A.FlagAlt_Key,
							A.FlagName,
							A.Date,
							A.Marking,
							A.MarkingAlt_Key,
							Amount,
							A.AuthorisationStatus, 
                            A.EffectiveFromTimeKey, 
                            A.EffectiveToTimeKey, 
                            A.CreatedBy, 
                            A.DateCreated, 
                            A.ApprovedBy, 
                            A.DateApproved, 
                            A.ModifiedBy, 
                            A.DateModified,
							A.crModBy,
							A.CrModDate,
							A.CrAppBy,
							A.CrAppDate,
							A.ModAppBy,
							A.ModAppDate;
                 SELECT *
                 FROM
                 (
                     SELECT ROW_NUMBER() OVER(ORDER BY DegrationAlt_Key) AS RowNumber, 
                            COUNT(*) OVER() AS TotalCount, 
                            'ExceptionalDegrationDetail' TableName, 
                            *
                     FROM
                     (
                         SELECT *
                         FROM #temp16 A
                         --WHERE ISNULL(BankCode, '') LIKE '%'+@BankShortName+'%'
                         --      AND ISNULL(BankName, '') LIKE '%'+@BankName+'%'
                     ) AS DataPointOwner
                 ) AS DataPointOwner

                 --WHERE RowNumber >= ((@PageNo - 1) * @PageSize) + 1
                 --      AND RowNumber <= (@PageNo * @PageSize)

   END

   ELSE
    IF (@OperationFlag in (20))

             BEGIN
			 IF OBJECT_ID('TemrefpDB..#temp20') IS NOT NULL
                 DROP TABLE #temp20;
                 SELECT A.DegrationAlt_Key,
							A.SourceName,
							A.SourceAlt_Key,
							A.AccountID,
							A.RefCustomerId AS CustomerID,
							A.FlagAlt_Key,
							A.FlagName,
							A.Date,
							A.Marking,
							A.MarkingAlt_Key,
							Amount,
							A.AuthorisationStatus, 
                            A.EffectiveFromTimeKey, 
                            A.EffectiveToTimeKey, 
                            A.CreatedBy, 
                            A.DateCreated, 
                            A.ApprovedBy, 
                            A.DateApproved, 
                            A.ModifiedBy, 
                            A.DateModified,
							A.CrModBy,
							A.CrModDate,
							A.CrAppBy,
							A.CrAppDate,
							A.ModAppBy,
							A.ModAppDate
                 INTO #temp20
                 FROM 
                 (
                     SELECT A.DegrationAlt_Key,
							B.SourceName,
							C.SourceAlt_Key,
							A.AccountID,
							C.RefCustomerId,
							S.FlagAlt_Key,
							S.FlagName,
							Convert(Varchar(20),A.Date,103) Date,
							H.ParameterName as Marking,
							A.MarkingAlt_Key,
							Amount,
							isnull(A.AuthorisationStatus, 'A') AuthorisationStatus, 
                            A.EffectiveFromTimeKey, 
                            A.EffectiveToTimeKey, 
                            A.CreatedBy, 
                            Convert(Varchar(20),A.DateCreated,103) DateCreated, 
                            A.ApprovedBy, 
                            Convert(Varchar(20),A.DateApproved,103) DateApproved, 
                            A.ModifiedBy, 
                            Convert(Varchar(20),A.DateModified,103) DateModified,
							IsNull(A.ModifiedBy,A.CreatedBy)as CrModBy

							,IsNull(A.DateModified,A.DateCreated)as CrModDate
							,ISNULL(A.ApprovedBy,A.CreatedBy) as CrAppBy
							,ISNULL(A.DateApproved,A.DateCreated) as CrAppDate
							,ISNULL(A.ApprovedBy,A.ModifiedBy) as ModAppBy
							,ISNULL(A.DateApproved,A.DateModified) as ModAppDate

                     FROM ExceptionalDegrationDetail_Mod A
					 Inner JOIn #ReminderReport1  S ON S.AccountID=A.AccountID  and S.FlagAlt_Key=A.FlagAlt_Key
					 Inner Join (Select ParameterAlt_Key,ParameterName,'DimYesNo' as Tablename 
						  from DimParameter where DimParameterName='DimYesNo'
						  And EffectiveFromTimeKey<=@TimeKey And EffectiveToTimeKey>=@TimeKey)H
						  ON H.ParameterAlt_Key=A.MarkingAlt_Key
						  left join dbo.AdvAcBasicDetail C
						  ON A.AccountID=C.CustomerACID
						  AND C.EffectiveFromTimeKey <= @TimeKey
                           AND C.EffectiveToTimeKey >= @TimeKey
						   left join  [dbo].[DIMSOURCEDB] B on C.SourceAlt_Key=B.SourceAlt_Key
					 WHERE A.EffectiveFromTimeKey <= @TimeKey
                           AND A.EffectiveToTimeKey >= @TimeKey
						   --AND A.AccountID=@AccountID
                           --AND ISNULL(AuthorisationStatus, 'A') IN('NP', 'MP', 'DP')
                           AND A.Entity_Key IN
                     (
                         SELECT MAX(Entity_Key)
                         FROM ExceptionalDegrationDetail_Mod
                         WHERE EffectiveFromTimeKey <= @TimeKey
                               AND EffectiveToTimeKey >= @TimeKey
                               AND ISNULL(AuthorisationStatus, 'A') IN('1A')
                         GROUP BY AccountID,FlagAlt_Key
                     )
                 ) A 
                      
                 
                 GROUP BY A.DegrationAlt_Key,
							A.SourceName,
							A.SourceAlt_Key,
							A.AccountID,
							A.RefCustomerId,
							A.FlagAlt_Key,
							A.FlagName,
							A.Date,
							A.Marking,
							A.MarkingAlt_Key,
							Amount,
							A.AuthorisationStatus, 
                            A.EffectiveFromTimeKey, 
                            A.EffectiveToTimeKey, 
                            A.CreatedBy, 
                            A.DateCreated, 
                            A.ApprovedBy, 
                            A.DateApproved, 
                            A.ModifiedBy, 
                            A.DateModified,
							A.crModBy,
							A.CrModDate,
							A.CrAppBy,
							A.CrAppDate,
							A.ModAppBy,
							A.ModAppDate;
                 SELECT *
                 FROM
                 (
                     SELECT ROW_NUMBER() OVER(ORDER BY DegrationAlt_Key) AS RowNumber, 
                            COUNT(*) OVER() AS TotalCount, 
                            'ExceptionalDegrationDetail' TableName, 
                            *
                     FROM
                     (
                         SELECT *
                         FROM #temp20 A
                         --WHERE ISNULL(BankCode, '') LIKE '%'+@BankShortName+'%'
                         --      AND ISNULL(BankName, '') LIKE '%'+@BankName+'%'
                     ) AS DataPointOwner
                 ) AS DataPointOwner

   END

   END TRY
	BEGIN CATCH
	
	INSERT INTO dbo.Error_Log
				SELECT ERROR_LINE() as ErrorLine,ERROR_MESSAGE()ErrorMessage,ERROR_NUMBER()ErrorNumber
				,ERROR_PROCEDURE()ErrorProcedure,ERROR_SEVERITY()ErrorSeverity,ERROR_STATE()ErrorState
				,GETDATE()

	SELECT ERROR_MESSAGE()
	--RETURN -1
   
	END CATCH

  
    END;
GO
