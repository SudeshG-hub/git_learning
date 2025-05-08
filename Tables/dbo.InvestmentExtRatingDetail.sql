CREATE TABLE [dbo].[InvestmentExtRatingDetail]
(
[EntityKey] [int] NOT NULL IDENTITY(1, 1),
[IssuerEntityID] [int] NULL,
[InstrumentEntityID] [int] NULL,
[RatingEntityID] [int] NULL,
[RatingAgencyAlt_Key] [smallint] NULL,
[RatingAlt_Key] [smallint] NULL,
[RatingDt] [date] NULL,
[RatingExpDt] [date] NULL,
[AuthorisationStatus] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EffectiveFromTimeKey] [int] NULL,
[EffectiveToTimeKey] [int] NULL,
[CreatedBy] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateCreated] [smalldatetime] NULL,
[ModifiedBy] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateModified] [smalldatetime] NULL,
[ApprovedBy] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateApproved] [smalldatetime] NULL,
[D2Ktimestamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
