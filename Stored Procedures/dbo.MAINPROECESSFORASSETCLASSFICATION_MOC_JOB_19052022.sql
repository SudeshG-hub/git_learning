SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE Proc [dbo].[MAINPROECESSFORASSETCLASSFICATION_MOC_JOB_19052022]

@Result SMALLINT=1 OUTPUT

AS

Declare
@JobStatus varchar(100) =''

SELECT @JobStatus =CASE isnull(jh.run_status,5) WHEN 0 THEN 'Error Failed'
  WHEN 1 THEN 'Succeeded'
  WHEN 2 THEN 'Retry'
  WHEN 3 THEN 'Cancelled'
  WHEN 4 THEN 'In Progress' 
  WHEN 5 THEN 'Other'
  ELSE
  'Processing' END
     FROM
   (msdb.dbo.sysjobactivity ja LEFT JOIN msdb.dbo.sysjobhistory jh ON ja.job_history_id = jh.instance_id) join msdb.dbo.sysjobs_view j on ja.job_id = j.job_id
   WHERE ja.session_id=(SELECT MAX(session_id) from msdb.dbo.sysjobactivity) and j.name='MAINPROECESSFORASSETCLASSFICATION_ENBD'

  
   PRINT @JobStatus
   if(@JobStatus='Processing')
    begin
      SET @Result=-2
       RETURN @Result 
     END
     ELSE
       BEGIN
    exec msdb.dbo.sp_start_job 'MAINPROECESSFORASSETCLASSFICATION'
            SET @Result=1
            RETURN @Result 
       END

GO
