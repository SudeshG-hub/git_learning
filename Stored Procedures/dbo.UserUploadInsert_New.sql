SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[UserUploadInsert_New]
	(
		@XmlDocument XML='',  
		@MenuId VARCHAR(1000),
		@LoginPassword	varchar(max),
		@EffectiveFromTimeKey INT,                       
		@EffectiveToTimeKey INT  ,              
		@DateCreatedmodified smalldatetime,
		@CreatedModifiedBy	varchar	(20),
		@TimeKey SMALLINT,
		@Result INT=0 OUTPUT
	)
AS
DECLARE @Entity_Key AS INT,
        @PasswordChanged char(1),
		@CurrentLoginDate Date--- added by shailesh naik on 10/06/2014

		IF ISNULL(@TimeKey,0)=0
		BEGIN
		  Select @TimeKey=TimeKey from SysDayMatrix where cast(Getdate() as Date)=[Date]
		END

		IF ISNULL(@EffectiveFromTimeKey,0)=0
		BEGIN
		  Select @EffectiveFromTimeKey=TimeKey from SysDayMatrix where cast(Getdate() as Date)=[Date]
		END

		--SET @TimeKey=(SELECT MAX(TIMEKEY) FROM sysprocessingcycle WHERE Extracted='Y')--ADDED BY MAMTA ON 21 JAN 2020 BECAUSE BYDEFAULT IT WAS PAASING 1 APRIL 2018 TIMEKEY
		SET @EffectiveFromTimeKey=@TimeKey--ADDED BY MAMTA ON 21 JAN 2020 BECAUSE BYDEFAULT IT WAS PAASING 1 APRIL 2018 TIMEKEY
	    SET @EffectiveToTimeKey=49999


BEGIN TRY
BEGIN TRANSACTION
		  IF OBJECT_ID('TEMPDB..#UserMasterUploadData')IS NOT NULL
			DROP TABLE #UserMasterUploadData
			--Select * from DimUserInfo
	 SELECT 
				
				 c.value('./SrNo[1]','int')SrNo
				,c.value('./UserID[1]','varchar(20)')UserID
				,c.value('./UserName[1]','varchar(100)')UserName
				,c.value('./UserRole[1]','varchar(50)')UserRole
				,c.value('./UserDepartment[1]','nvarchar(510)')UserDepartment				
				--,c.value('./ApplicableSolID[1]','varchar(max)')ApplicableSolID
				,c.value('./ApplicableBACID[1]','varchar(max)')ApplicableBACID
				,c.value('./UserEmailId[1]','varchar(200)')UserEmailId
				,c.value('./UserMobileNumber[1]','varchar(15)')UserMobileNumber
				,c.value('./UserExtensionNumber [1]','varchar(15)')UserExtensionNumber
				,c.value('./IsCheckerYN[1]','varchar(1)')IsChecker
				,c.value('./IsChecker2YN[1]','varchar(max)')IsChecker2 ---Added By Sachin
				,c.value('./IsActiveYN [1]','varchar(1)')IsActive
				,c.value('./ActionAU[1]','varchar(1)')Perform						
				
				INTO #UserMasterUploadData
				FROM @XmlDocument.nodes('/DataSet/GridData') AS t(c)

	 Alter table #UserMasterUploadData
	 Add CreatedBy varchar(50),DateCreated smalldatetime,UserRoleAlt_Key smallint,DeptGroupCode varchar(10),DepartmentId int
	 ,ScreenFlag char(1)

	 uPDATE #UserMasterUploadData SET ---ApplicableSolID =REPLACE(REPLACE(ApplicableSolID, CHAR(13), ''), CHAR(10), '')
				
				ApplicableBACID =REPLACE(REPLACE(ApplicableBACID, CHAR(13), ''), CHAR(10), ''),UserRole=LTRIM(RTRIM(UserRole))

	 Update U
	 Set U.CreatedBy=US.CreatedBy
	 ,U.DateCreated=Us.DateCreated
	 from #UserMasterUploadData U
	 inner join DimUserInfo Us ON (US.EffectiveFromTimeKey<=@TimeKey AND US.EffectiveToTimeKey >=@TimeKey)
	 AND U.UserID=US.UserLoginID
	 AND U.Perform='U'

	

	  Update U
	 Set U.CreatedBy=@CreatedModifiedBy
	 ,U.DateCreated=GETDATE()
	 from #UserMasterUploadData U
	 inner join DimUserInfo Us ON (US.EffectiveFromTimeKey<=@TimeKey AND US.EffectiveToTimeKey >=@TimeKey)
	 AND U.UserID=US.UserLoginID
	 AND U.Perform='A'

	   Update U
	 Set U.UserRoleAlt_Key=R.UserRoleAlt_Key
	 
	 from #UserMasterUploadData U
	 inner join DimUserRole R ON R.EffectiveFromTimeKey<=@TimeKey AND R.EffectiveToTimeKey >=@TimeKey
	 and R.RoleDescription=U.UserRole

	   Update U
	 Set U.DepartmentId=D.DeptGroupId
	 
	 from #UserMasterUploadData U
	 --inner join DimDepartment D ON D.EffectiveFromTimeKey<=@TimeKey AND D.EffectiveToTimeKey >=@TimeKey
	 --and D.DepartmentCode=U.UserDepartment

	  inner join DimUserDeptGroup D ON D.EffectiveFromTimeKey<=@TimeKey AND D.EffectiveToTimeKey >=@TimeKey
	 and D.DeptGroupCode=U.UserDepartment

	  Update U
	 Set U.DeptGroupCode=G.DeptGroupId
	 
	 from #UserMasterUploadData U
	 --inner join DimDepartment D ON D.EffectiveFromTimeKey<=@TimeKey AND D.EffectiveToTimeKey >=@TimeKey
	 --and D.DepartmentCode=U.UserDepartment
	 inner join DimUserDeptGroup G ON G.EffectiveFromTimeKey<=@TimeKey AND G.EffectiveToTimeKey >=@TimeKey
	 and G.DeptGroupCode=U.UserDepartment

	 --inner join DimUserDeptGroup G ON (G.EffectiveFromTimeKey<=@TimeKey AND G.EffectiveToTimeKey >=@TimeKey)
	 --AND G.DeptGroupName =
	 --(
	 --  Case WHEN U.UserDepartment IN ('BBOG','FNA') THEN U.UserDepartment +  '_' +Cast(U.UserRoleAlt_Key as Varchar(10))
	 --  else 'OTHER' +  '_' +Cast(U.UserRoleAlt_Key as Varchar(10)) end
	 --)

	  Update US
	 Set US.EffectiveToTimeKey=@EffectiveFromTimeKey-1
	 from #UserMasterUploadData U
	 inner join DimUserInfo Us ON (US.EffectiveFromTimeKey<=@TimeKey AND US.EffectiveToTimeKey >=@TimeKey)
	 AND U.UserID=US.UserLoginID
	 AND U.Perform='U'

	 INSERT INTO DimUserInfo         
					(
						UserLoginID
						,EmployeeID 
						,IsEmployee 
						,UserName
						,LoginPassword 
						,UserLocation 
						,DeptGroupCode 
						,Activate  
						,IsChecker 
						,EffectiveFromTimeKey                          
						,EffectiveToTimeKey               
						----,EntityKey 
						,PasswordChanged
						--------
						,PasswordChangeDate
						,ChangePwdCnt
						,UserLocationCode
						,UserRoleAlt_Key
						,SuspendedUser
						,CurrentLoginDate
						,ResetDate
						,UserLogged
						,UserDeletionReasonAlt_Key
						,SystemLogOut
						,RBIFLAG

						,Email_ID	--ad4
						,MobileNo
						,DesignationAlt_Key
						,IsCma

						,SecuritQsnAlt_Key
						,SecurityAns
						,MenuId
						,CreatedBy
						,DateCreated
						,ModifyBy
						,DateModified
						,MIS_APP_USR_ID
						,MIS_APP_USR_PASS
						,UserLocationExcel
						,WorkFlowUserRoleAlt_Key
						,ApplicableBACID	
						----,ApplicableSolIds
						,DepartmentId	
						,ScreenFlag
						,IsChecker2
					)        
				SELECT		
						 UserID
						,UserID
						,'Y'
						,UserName
						,@LoginPassword 
						,'HO'
						,DeptGroupCode
						,IsActive  
						,IsChecker 
						,@EffectiveFromTimeKey                       
						,@EffectiveToTimeKey                
						----,@Entity_Key 
						,'N' PasswordChanged 
						--------------
						,NULL PasswordChangeDate
						,0 ChangePwdCnt
						, 'HO' UserLocationCode
						,UserRoleAlt_Key
						,'N'SuspendedUser
						,NULL CurrentLoginDate
						,NULL ResetDate
						,NULL UserLogged
						,NULL UserDeletionReasonAlt_Key
						,NULL SystemLogOut
						,NULL RBIFLAG

						,UserEmailId	--ad4
						,UserMobileNumber + ',' + UserExtensionNumber
						,NULL DesignationAlt_Key
						,NULL IsCma

						,NULL SecuritQsnAlt_Key
						,NULL SecurityAns
						,NULL MenuId
						--,CreatedBy
						--,dateCreated
						,@CreatedModifiedBy
						,@DateCreatedmodified
						,CASE WHEN Perform='A' THEN NULL ELSE @CreatedModifiedBy END
						,CASE WHEN Perform='A' THEN NULL ELSE @DateCreatedmodified END
						,NULL MIS_APP_USR_ID
						,NULL MIS_APP_USR_PASS
						,NULL UserLocationExcel
						,NULL WorkFlowUserRoleAlt_Key
						,ApplicableBACID	
						----,ApplicableSolId
						,DepartmentId	
						,'U'
						,IsChecker2
					FROM #UserMasterUploadData

					

Commit Transaction
SET @Result=1
return @Result
END TRY
BEGIN CATCH
		   
	        
			ROLLBACK TRANSACTION
			Print 'Error'
			SELECT @Result = -1
			RETURN -1        
		        
	
END CATCH
 
GO
