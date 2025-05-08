SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/****** Object:  StoredProcedure [dbo].[SourceSystemHistory]    Script Date: 25-02-2021 16:58:23 ******/

CREATE PROC [dbo].[RefPeriodMasterHistory_20042022]
@RuleAlt_Key INt
						--@SourceAlt_Key Int

AS
	BEGIN

	
			Select A.Rule_Key,
					A.RuleAlt_Key,
					A.BusinessRule,
					A.SourceSystemAlt_Key as SourceAlt_Key,
					B.SourceName as SourceSysName,
					A.IRACParameter,
					A.RefValue as DPD,
					A.RefUnit as ReferenceUnit,
					A.Grade,
					A.CreatedBy, 
					Convert(Varchar(20),A.DateCreated,103) DateCreated,
					A.ApprovedBy, 
					Convert(Varchar(20),A.DateApproved,103) DateApproved,
					A.ModifiedBy, 
					Convert(Varchar(20),A.DateModified,103) DateModified
					FROM Pro.RefPeriod A
					 Inner Join DimSourceDB B ON A.SourceSystemAlt_Key=B.SourceAlt_Key And B.EffectiveToTimeKey=49999
					 
					 WHERE A.RuleAlt_Key=@RuleAlt_Key
					 And ISNULL(A.AuthorisationStatus,'A')='A'
					 AND A.BusinessRule In ('RefPeriodOverdue','RefPeriodOverDrawn','RefPeriodNoCredit',
												'RefPeriodStkStatement','RefPeriodReview',
												'Refperiodoverdueupg','Refperiodoverdrawnupg',
												'Refperiodreviewupg','Refperiodstkstatementupg','Refperiodnocreditupg','RefPeriodOverdueDerivative','RefPeriodOverdueInvestment')
UNION 

			Select A.Rule_Key,
					A.RuleAlt_Key,
					A.BusinessRule,
					A.SourceSystemAlt_Key as SourceAlt_Key,
					B.SourceName as SourceSysName,
					A.IRACParameter,
					A.RefValue as DPD,
					A.RefUnit as ReferenceUnit,
					A.Grade,
					A.CreatedBy, 
					Convert(Varchar(20),A.DateCreated,103) DateCreated,
					A.ApprovedBy, 
					Convert(Varchar(20),A.DateApproved,103) DateApproved,
					A.ModifiedBy, 
					Convert(Varchar(20),A.DateModified,103) DateModified
					FROM Pro.RefPeriod_Mod A
					 Inner Join DimSourceDB B ON A.SourceSystemAlt_Key=B.SourceAlt_Key And B.EffectiveToTimeKey=49999
					 
					 WHERE A.RuleAlt_Key=@RuleAlt_Key
					 And ISNULL(A.AuthorisationStatus,'A')='A' --in ('NP','MP','FM','1A','R')
					 AND A.BusinessRule In ('RefPeriodOverdue','RefPeriodOverDrawn','RefPeriodNoCredit',
												'RefPeriodStkStatement','RefPeriodReview',
												'Refperiodoverdueupg','Refperiodoverdrawnupg',
												'Refperiodreviewupg','Refperiodstkstatementupg','Refperiodnocreditupg','RefPeriodOverdueDerivative','RefPeriodOverdueInvestment')


	END
GO
