CREATE TABLE [dbo].[WilfulDirectorDetailOtherOwner]
(
[Entity_Key] [int] NOT NULL IDENTITY(1, 2),
[DirectorName] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PAN] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DIN] [numeric] (8, 2) NULL,
[DirectorTypeAlt_Key] [int] NULL,
[AuthorisationStatus] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EffectiveFromTimeKey] [int] NULL,
[EffectiveToTimeKey] [int] NULL,
[CreatedBy] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateCreated] [date] NULL,
[ModifiedBy] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateModified] [date] NULL,
[ApprovedBy] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateApproved] [date] NULL
) ON [PRIMARY]
GO
