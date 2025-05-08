CREATE TABLE [dbo].[DimOccupation]
(
[Occupation_Key] [smallint] NOT NULL,
[OccupationAlt_Key] [smallint] NOT NULL,
[OccupationOrderKey] [tinyint] NULL,
[OccupationName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OccupationShortName] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OccupationShortNameEnum] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OccupationGroup] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OccupationSubGroup] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OccupationSegment] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OccupationValidCode] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[VillageOccupation] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SrcSysOccupationCode] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SrcSysOccupationName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DestSysOccupationCode] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AuthorisationStatus] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EffectiveFromTimeKey] [int] NULL,
[EffectiveToTimeKey] [int] NULL,
[CreatedBy] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateCreated] [smalldatetime] NULL,
[ModifiedBy] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateModifie] [smalldatetime] NULL,
[ApprovedBy] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateApproved] [smalldatetime] NULL,
[D2Ktimestamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
