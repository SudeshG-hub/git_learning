SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE procedure [dbo].[testtemptomain]
as

delete from AdvAcBasicDetail 
delete from AdvAcBalanceDetail 
delete from AdvAcFinancialDetail 
delete from AdvAcOtherFinancialDetail 
delete from AdvCustNPADetail 
delete from CustomerBasicDetail 
delete from AdvCustOtherDetail 
delete from AdvAcOtherDetail 
delete from AdvAcOtherFinancialDetail 
delete from ADVFACCCDETAIL 
delete from AdvFacBillDetail 
delete from ADVFACDLDETAIL 
delete from AcDailyTxnDetail 
delete from AdvSecurityDetail 
delete from AdvSecurityValueDetail 
delete from InvestmentIssuerDetail 
delete from InvestmentBasicDetail 
delete from InvestmentFinancialDetail 
delete from Curdat.DerivativeDetail 
delete from PRO.ContExcsSinceDtAccountCal 
delete from Curdat.AdvAcWODetail 
delete from Pro.customercal_hist
delete from Pro.accountcal_hist
delete from reversefeeddata
delete from AdvNFAcBasicDetail 
delete from AdvNFAcFinancialDetail
delete from AdvFacNFDetail

delete from ENBD_STGDB.dbo.package_audit --where cast(Execution_date as date) = '02/24/2022'

update ENBD_STGDB.dbo.Automate_Advances set EXT_FLG = 'N' where EXT_FLG = 'Y'

update ENBD_STGDB.dbo.Automate_Advances set EXT_FLG = 'Y' where Timekey = 26371

update Automate_Advances set EXT_FLG = 'N' where EXT_FLG = 'Y'

update Automate_Advances set EXT_FLG = 'Y' where Timekey = 26371

--for Finacle : 26297 For calypso : 26328

GO
