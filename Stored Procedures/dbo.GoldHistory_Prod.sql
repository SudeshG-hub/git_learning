SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create PROC [dbo].[GoldHistory_Prod]

						@KaretMasterAlt_Key Int

AS
	BEGIN

declare @ProcessDate Datetime

Set @ProcessDate =(select DataEffectiveFromDate from SysDataMatrix where CurrentStatus='C')
--select @ProcessDate

		BEGIN

					Select	A.KaretMasterAlt_Key
					,A.KaretMasterValueName 
					,Convert(VARCHAR(20),A.KaretMasterValueDt,103) KaretMasterValueDt
					,A.KaretMasterValueAmt
					,A.SrcSysKaretValueCode
					,A.SrcSysKaretValueName
					,A.CreatedBy 
					,Convert(Varchar(20),A.DateCreated,103) DateCreated
					,A.ApprovedBy
					,Convert(Varchar(20),A.DateApproved,103) DateApproved
					,A.ModifiedBy 
					,Convert(Varchar(20),A.DateModifie,103) DateModified,
					convert(varchar(20),S1.date ,103) as EffectiveFromDate,
					convert(varchar(20),S2.date ,103) as EffectiveToDate 
					FROM DimKaretMaster A
					inner join sysdaymatrix S1 ON S1.Timekey=A.EffectiveFromTimekey
					inner join sysdaymatrix S2 ON S2.Timekey=A.EffectiveToTimekey

					Where A.KaretMasterAlt_Key=@KaretMasterAlt_Key
					And A.KaretMasterValueDt between @ProcessDate and @ProcessDate-15

		END

	END

GO
