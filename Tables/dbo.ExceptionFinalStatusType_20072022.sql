CREATE TABLE [dbo].[ExceptionFinalStatusType_20072022]
(
[Entity_Key] [int] NOT NULL IDENTITY(1, 1),
[SourceAlt_Key] [int] NULL,
[CustomerID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ACID] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[StatusType] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[StatusDate] [date] NULL,
[Amount] [decimal] (18, 2) NULL,
[AuthorisationStatus] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EffectiveFromTimeKey] [int] NULL,
[EffectiveToTimeKey] [int] NULL,
[CreatedBy] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateCreated] [datetime] NULL,
[ModifyBy] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateModified] [date] NULL,
[ApprovedBy] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateApproved] [date] NULL
) ON [PRIMARY]
GO
