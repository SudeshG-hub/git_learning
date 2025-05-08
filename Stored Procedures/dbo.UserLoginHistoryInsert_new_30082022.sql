SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------



-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].[UserLoginHistoryInsert_new_30082022]
	@UserID VARCHAR(20),
	@IPAdress VARCHAR(20),
	@LoginTime SMALLDATETIME,
	@LogoutTime SMALLDATETIME,
	@LoginSucceeded CHAR(1),
	@Result int = -1 output,
	@LastLoginOut	VARCHAR(50) output
AS

	DECLARE @UNLOGON AS INT
	Declare @TimeKey INT
	Declare @TimeKeyCurrent INT

	IF @LoginSucceeded='N'
	begin
	  set @LoginSucceeded='W'
	END

BEGIN

	SET @TimeKey = (SELECT  TimeKey  FROM    SysDataMatrix WHERE  CurrentStatus = 'C' )


	select @TimeKeyCurrent =TimeKey from sysdaymatrix where date=convert(date,getdate(),103)
	SET @UNLOGON = (SELECT ParameterValue FROM  DimUserParameters
					WHERE (EffectiveFromTimeKey < = @TimeKey  AND EffectiveToTimeKey  > = @TimeKey)
					AND ShortNameEnum='UNLOGON')
	Print @UNLOGON
	Print '@UNLOGO'
	SELECT @LastLoginOut=  'You last logged in at '	+ FORMAT(CONVERT(DATETIME,Convert(Varchar(5),CONVERT(TIME,MAX(LoginTime)))), 'hh:mm tt') +' on '+ CONVERT(varchar(11),MAX(LoginTime),100) 
	FROM  UserLoginHistory 
	WHERE UserID=@UserID

	IF @LastLoginOut = '' OR @LastLoginOut IS NULL
		SET @LastLoginOut = 'You last logged in at 00:00AM'

	IF(@LoginSucceeded='Y')
		BEGIN
		   BEGIN TRANSACTION
		BEGIN TRY
		PRINT 'INSERT IN UserLoginHistoryTable'
			INSERT INTO  UserLoginHistory
						(
							UserID
							,IP_Address
							,LoginTime
							,LogoutTime
							,DurationMin
							,LoginSucceeded
						)
				VALUES
					(
						@UserID,
						@IPAdress,
						@LoginTime,
						@LogoutTime,  ----change (as Discussed with Amol)
						NULL,
						@LoginSucceeded
					)
						UPDATE UserLoginHistory SET LoginSucceeded='Y'
										WHERE  UserID=@UserID
										AND LoginSucceeded='W'
						--Update  DimUserInfo SET UserLogged=1 ,CurrentLoginDate=GETDATE() 
						Update  DimUserInfo SET CurrentLoginDate=GETDATE() 
						where (EffectiveFromTimeKey<=@TimeKeyCurrent AND EffectiveToTimeKey>=@TimeKeyCurrent)
						AND   UserLoginID=@UserID

			COMMIT TRANSACTION
		END TRY
		BEGIN CATCH
			PRINT 'error'
			PRINT ERROR_MESSAGE()
			ROLLBACK TRANSACTION
			SET @Result= -1
			RETURN -1
			SELECT -1
		END CATCH
			SELECT @Result = MAX(EntityKey) FROM  UserLoginHistory 
			WHERE UserID=@UserID
				AND IP_Address=@IPAdress
				AND LoginTime=@LoginTime
				AND LoginSucceeded=@LoginSucceeded
		END


	ELSE IF(@LoginSucceeded='W')
		BEGIN
		   BEGIN TRANSACTION
		BEGIN TRY
		PRINT 'INSERTING INTO UserLoginHistory For Login Succeeded W'
			INSERT INTO  UserLoginHistory
				(
							UserID
							,IP_Address
							,LoginTime
							,LogoutTime
							,DurationMin
							,LoginSucceeded
						)
				VALUES
					(
						@UserID,
						@IPAdress,
						@LoginTime,
						NULL,
						NULL,
						@LoginSucceeded
					)
			PRINT 'Insertion Done'
					IF ((SELECT COUNT(LoginSucceeded) FROM UserLoginHistory 
													  WHERE  UserID=@UserID  AND LoginSucceeded='W'
															AND LoginSucceeded=@LoginSucceeded) >= @UNLOGON )

					BEGIN

						UPDATE DimUserInfo SET SuspendedUser='Y',UserLogged=0
										WHERE  UserLoginID=@UserID

					END

			COMMIT TRANSACTION
		END TRY
		BEGIN CATCH
			PRINT 'error'
			PRINT ERROR_MESSAGE()
			ROLLBACK TRANSACTION
			SET @Result= -1
			RETURN -1
			SELECT -1
		END CATCH


			DECLARE @LastLoginKey INT
			PRINT 'A'
			SELECT @LastLoginKey=MAX(EntityKey) FROM  UserLoginHistory 
			 WHERE  UserID=@UserID
						AND LoginSucceeded='Y'
			SET @LastLoginKey=ISNULL(@LastLoginKey,0)
			SELECT  @Result = (SELECT COUNT(LoginSucceeded)
						 FROM UserLoginHistory 
						 WHERE  UserID=@UserID
						AND LoginSucceeded='W'
						AND EntityKey>@LastLoginKey)
		
			

		END

	ELSE
		begin
		BEGIN TRANSACTION
		BEGIN TRY
			INSERT INTO  UserLoginHistory
				(
							UserID
							,IP_Address
							,LoginTime
							,LogoutTime
							,DurationMin
							,LoginSucceeded
						)
					VALUES
					(
					@UserID,
					@IPAdress,
					@LoginTime,
					@LogoutTime,
					NULL,
					@LoginSucceeded
					)
			
		COMMIT TRANSACTION
		END TRY
		BEGIN CATCH
			PRINT 'error'
			PRINT ERROR_MESSAGE()
			ROLLBACK TRANSACTION
			SET @Result= -1
			RETURN -1
			SELECT -1
		END CATCH
			


	 	SELECT  @Result =  MAX(EntityKey) FROM  UserLoginHistory 
		WHERE  UserID=@UserID
			AND IP_Address=@IPAdress
			AND LoginTime=@LoginTime
			AND LoginSucceeded=@LoginSucceeded
		
		END
END


--SELECT * FROM  UserLoginHistory 

GO
