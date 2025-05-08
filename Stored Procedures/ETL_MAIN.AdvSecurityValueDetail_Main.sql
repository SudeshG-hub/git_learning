SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [ETL_MAIN].[AdvSecurityValueDetail_Main]
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @VEFFECTIVETO INT SET @VEFFECTIVETO=(SELECT TIMEKEY-1 FROM ENBD_MISDB.DBO.AUTOMATE_ADVANCES WHERE EXT_FLG='Y')

----------For New Records
UPDATE A SET A.IsChanged='N'
----Select * 
from ENBD_TEMPDB.DBO.TempAdvSecurityValueDetail A
Where Not Exists(Select 1 from DBO.AdvSecurityValueDetail B Where B.EffectiveToTimeKey=49999
And  A.SecurityEntityID=B.SecurityEntityID)

UPDATE O SET O.EffectiveToTimeKey=@vEffectiveto,
 O.DateModified=CONVERT(DATE,GETDATE(),103),
 O.ModifiedBy='SSISUSER'

FROM DBO.AdvSecurityValueDetail AS O
INNER JOIN ENBD_TEMPDB.DBO.TempAdvSecurityValueDetail AS T
ON O.SecurityEntityID=T.SecurityEntityID
AND O.EffectiveToTimeKey=49999
AND T.EffectiveToTimeKey=49999

WHERE 
(
  o.ValuationSourceAlt_Key <> T.ValuationSourceAlt_Key 
OR o.ValuationDate <> T.ValuationDate 
OR o.CurrentValue <> T.CurrentValue 
OR o.ValuationExpiryDate <> T.ValuationExpiryDate 
 
     )



----------For Changes Records
UPDATE A SET A.IsChanged='C'
----Select * 
from ENBD_TEMPDB.DBO.TempAdvSecurityValueDetail A
INNER JOIN DBO.AdvSecurityValueDetail B 
ON  A.SecurityEntityID=B.SecurityEntityID
Where B.EffectiveToTimeKey= @vEffectiveto

---------------------------------------------------------------------------------------------------------------

-------Expire the records
UPDATE AA
SET 
 EffectiveToTimeKey = @vEffectiveto,
 DateModified=CONVERT(DATE,GETDATE(),103),
 ModifiedBy='SSISUSER' 
FROM DBO.AdvSecurityValueDetail AA
WHERE AA.EffectiveToTimeKey = 49999
AND NOT EXISTS (SELECT 1 FROM ENBD_TEMPDB.DBO.TempAdvSecurityValueDetail BB
    WHERE  AA.SecurityEntityID=BB.SecurityEntityID
    AND BB.EffectiveToTimeKey =49999
    )


	

INSERT INTO DBO.AdvSecurityValueDetail
     (	
      ENTITYKEY
,SecurityEntityID
,ValuationSourceAlt_Key
,ValuationDate
,CurrentValue
,ValuationExpiryDate
,AuthorisationStatus
,EffectiveFromTimeKey
,EffectiveToTimeKey
,CreatedBy
,DateCreated
,ModifiedBy
,DateModified
,ApprovedBy
,DateApproved
,D2Ktimestamp
,CurrentValueSource
,CollateralValueatthetimeoflastreviewinRs
,CollateralID
,ExpiryBusinessRule
,PeriodinMonth
		   )
SELECT
				
	  ENTITYKEY
,SecurityEntityID
,ValuationSourceAlt_Key
,ValuationDate
,CurrentValue
,ValuationExpiryDate
,AuthorisationStatus
,EffectiveFromTimeKey
,EffectiveToTimeKey
,CreatedBy
,DateCreated
,ModifiedBy
,DateModified
,ApprovedBy
,DateApproved
,D2Ktimestamp
,NULL CurrentValueSource
,NULL CollateralValueatthetimeoflastreviewinRs
,NULL CollateralID
,NULL ExpiryBusinessRule
,NULL PeriodinMonth
	  FROM ENBD_TEMPDB.dbo.TempAdvSecurityValueDetail T Where ISNULL(T.IsChanged,'U') IN ('N','C')


END


  

GO
