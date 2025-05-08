CREATE TABLE [dbo].[RetsructuredAssetsUpload_stg]
(
[SrNo] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AccountID] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RestructureFacility] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EquityConversion] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateofConversionintoEquity] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PrinRpymntStartDate] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[InttRpymntStartDate] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TypeofRestructuring] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BankingRelationship] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateofRestructuring] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RestructuringApprovingAuth] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateofIstDefaultonCRILIC] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ReportingBank] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AmountRstrctr] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[InvestmentGrade] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[StatusofSpecificPeriod] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DFVProvisionRs] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MTMProvisionRs] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[filname] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Entity_Key] [bigint] NOT NULL IDENTITY(1, 1)
) ON [PRIMARY]
GO
