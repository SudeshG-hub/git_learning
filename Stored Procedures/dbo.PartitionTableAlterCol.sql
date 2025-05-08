SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/* This SP is usedfor in case column alter/add in a table that should be add/alter in all partition ab/tables*/

CREATE PROC [dbo].[PartitionTableAlterCol]
	 @ObjectName varchar(256)='AdvAcBasicDetail'
	,@TSQLCommand varchar(max)='Alter Table Curdat.AdvAcBasicDetail ADD customeracid varchar(30)'
AS
			DECLARE @SQL varchar(max)=''

		
		
	DECLARE @PartitionFreq  varchar(3)
			,@DB_Name VARCHAR(50)
			,@TableSuffix varchar(100)
		SET @DB_Name =(SELECT DB_NAME())
	
		set @TSQLCommand=REPLACE(@TSQLCommand,'Alter Table','')
		set @TSQLCommand=REPLACE(@TSQLCommand,'CURdAT.'+@ObjectName,'')
	
		SELECT @PartitionFreq=PartitionFreq FROM DimPartitionTable WHERE PartitionTbaleName=@ObjectName
				
		IF @PartitionFreq='MLY'		SET @TableSuffix='Jan,Feb,Mar,Apr,May,Jun,Jul,Aug,Sep,Oct,Nov,Dec'

		IF @PartitionFreq='QLY'		SET @TableSuffix='Q1,Q2,Q3,Q4'

		DROP TABLE IF EXISTS #DB_LIST 
		CREATE TABLE #DB_LIST (DbName varchar(50), ID TinyInt)
		
		print 11
		INSERT INTO #DB_LIST
		SELECT Name, 1 iD FROM SYS.databases WHERE NAME LIKE @DB_NAME+'%' 
		and isnumeric(RIGHT(NAME,4) )=1
		AND RIGHT(NAME,4)  BETWEEN 2019 AND 2099 AND LEN(NAME)=LEN(@DB_NAME)+5  
		print 12
		select *  from #DB_LIST

		SET @SQL= ' USE '+ @DB_Name+ CHAR(13)+' '
				
			
		SELECT @SQL=CHAR(13)+ STRING_AGG(QRY,'')
		FROM(
					SELECT ' ALTER TABLE '+DbName+'.DBO.'+@ObjectName+'_'+RIGHT(DbName,4)+'_'+VALUE +@TSQLCommand  QRY FROM #DB_LIST A
					INNER JOIN  
							(SELECT 1 ID, value FROM STRING_SPLIT(@TableSuffix,',')  
							)  B
					ON A.ID=B.ID
			) A
		--SELECT @SQL
		--print 2
		---print @SQL
		EXEC(@SQL)
		
		set @SQL='exec sp_refreshview '''+ @ObjectName+''''
		print @SQL
		exec (@SQL)




GO
