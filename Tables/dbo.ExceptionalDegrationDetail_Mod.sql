CREATE TABLE [dbo].[ExceptionalDegrationDetail_Mod]
(
[Entity_Key] [int] NOT NULL IDENTITY(1, 1),
[DegrationAlt_Key] [int] NULL,
[SourceAlt_Key] [int] NULL,
[AccountID] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomerID] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FlagAlt_Key] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Date] [date] NULL,
[AuthorisationStatus] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Remark] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ChangeFields] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EffectiveFromTimeKey] [int] NULL,
[EffectiveToTimeKey] [int] NULL,
[CreatedBy] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateCreated] [smalldatetime] NULL,
[ModifiedBy] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateModified] [smalldatetime] NULL,
[ApprovedBy] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateApproved] [smalldatetime] NULL,
[D2Ktimestamp] [timestamp] NOT NULL,
[MarkingAlt_Key] [int] NULL,
[Amount] [decimal] (18, 2) NULL,
[DateApprovedFirstLevel] [datetime] NULL,
[ApprovedByFirstLevel] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
