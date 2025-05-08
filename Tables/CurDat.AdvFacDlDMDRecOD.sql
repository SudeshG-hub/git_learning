CREATE TABLE [CurDat].[AdvFacDlDMDRecOD]
(
[EntityKey] [bigint] NOT NULL IDENTITY(1, 1),
[BranchCode] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AccountEntityID] [int] NOT NULL,
[TimeKey] [int] NOT NULL,
[RefSystemACID] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PrincipalDemand] [decimal] (14, 0) NULL,
[InttDemand] [decimal] (14, 0) NULL,
[OthDemand] [decimal] (14, 0) NULL,
[CurrentDemand] [decimal] (14, 2) NULL,
[Overdue] [decimal] (14, 2) NULL,
[OverduePeriod_Months] [int] NULL,
[OverdueUpto1Month] [decimal] (14, 0) NULL,
[OverdueMore1MonthTo2Month] [decimal] (14, 0) NULL,
[OverdueMore2MonthTo3Month] [decimal] (14, 0) NULL,
[OverdueUpto1Year] [decimal] (14, 0) NULL,
[OverdueMore1YearTo2Year] [decimal] (14, 0) NULL,
[OverdueMore2YearTo3Year] [decimal] (14, 0) NULL,
[OverdueMore3YearTo4Year] [decimal] (14, 0) NULL,
[OverdueMore4YearTo5Year] [decimal] (14, 0) NULL,
[OverdueAbove5Year] [decimal] (14, 0) NULL,
[EntityClosureDate] [smalldatetime] NULL,
[EntityClosureReasonAlt_Key] [smallint] NULL,
[AdvanceRec] [decimal] (14, 0) NULL,
[CurrentAdjustment] [decimal] (14, 2) NULL,
[RepaymentScheduleNum] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
