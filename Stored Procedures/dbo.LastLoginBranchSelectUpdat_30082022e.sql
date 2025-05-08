SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO






create PROCEDURE [dbo].[LastLoginBranchSelectUpdat_30082022e] 
    @BranchCode		VARCHAR(20),
    @Type			VARCHAR(10),
	@userLoginId	VARCHAR(20)
AS
BEGIN
		DECLARE @Maxkey INT 
		IF	@Type = 'Login'
		BEGIN
			
			SELECT @Maxkey= MAX(EntityKey) FROM UserLoginHistory WHERE UserID =@userLoginId and BranchCode is not null

			SELECT BranchCode FROM UserLoginHistory WHERE EntityKey = @Maxkey

		END
		ELSE IF @Type = 'Logout'
		BEGIN
			
			SELECT @Maxkey= MAX(EntityKey) FROM UserLoginHistory WHERE UserID =@userLoginId
			
			UPDATE UserLoginHistory SET BranchCode = @BranchCode WHERE EntityKey = @Maxkey

			SELECT BranchCode FROM UserLoginHistory WHERE EntityKey = @Maxkey

				Declare @TimeKeyCurrent INT
			SET @TimeKeyCurrent = (select TimeKey from sysdaymatrix where date=convert(date,getdate(),103))
			Update DimUserInfo Set UserLogged=0 where (EffectiveFromTimeKey<=@TimeKeyCurrent AND EffectiveToTimeKey>=@TimeKeyCurrent)
			AND UserLoginID=@userLoginId

		END
END



















GO
