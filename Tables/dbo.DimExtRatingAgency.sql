CREATE TABLE [dbo].[DimExtRatingAgency]
(
[RatingAgency_Key] [smallint] NOT NULL,
[RatingAgencyAlt_Key] [smallint] NULL,
[RatingAgencyName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RatingAgencyShortName] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RatingAgencyShortNameEnum] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RatingAgencyGroup] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SrcSysRatingAgencyCode] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SrcSysRatingAgencyName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DestSysRatingAgencyNameCode] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CibilAssetmentAgency_Authority] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AuthorisationStatus] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EffectiveFromTimeKey] [int] NULL,
[EffectiveToTimeKey] [int] NULL,
[CreatedBy] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateCreated] [smalldatetime] NULL,
[ModifyBy] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateModified] [smalldatetime] NULL,
[ApprovedBy] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateApproved] [smalldatetime] NULL,
[D2Ktimestamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
