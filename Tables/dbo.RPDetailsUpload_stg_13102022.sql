CREATE TABLE [dbo].[RPDetailsUpload_stg_13102022]
(
[Entity_Key] [int] NOT NULL IDENTITY(1, 1),
[SrNo] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UCICID] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomerID] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BorrowerPAN] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[1stReportingBankLenderCode] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BankingArrangement] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Nameofleadbank] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Exposurebucket] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ReferenceDate] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ICAStatus] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ReasonfornotsigningICA] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ICAExecutionDate] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ApproveddateofResolutionPlan] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NatureofRP] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IfOtherRPDescription] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IBCFilingDate] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IBCAdmissiondate] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ImplementationStatus] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ActualRPImplDate] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RevisedRPDeadline] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OutofdefaultdateallbankspostinitialRPdeadline] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IfRPisRectificationthenRiskReviewTimeline] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[filname] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
