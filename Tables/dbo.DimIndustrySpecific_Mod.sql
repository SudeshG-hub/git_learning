CREATE TABLE [dbo].[DimIndustrySpecific_Mod]
(
[Entity_Key] [int] NOT NULL IDENTITY(1, 1),
[SlNo] [int] NULL,
[CIF] [int] NULL,
[BSRActivityCode] [int] NULL,
[ProvisionRate] [decimal] (18, 2) NULL,
[AuthorisationStatus] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EffectiveFromTimeKey] [int] NULL,
[EffectiveToTimeKey] [int] NULL,
[CreatedBy] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateCreated] [date] NULL,
[ModifyBy] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateModified] [date] NULL,
[ApprovedBy] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateApproved] [date] NULL,
[UploadID] [int] NULL,
[SummaryID] [int] NULL,
[ApprovedByFirstlevel] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateApprovedFirstLevel] [smalldatetime] NULL
) ON [PRIMARY]
GO
