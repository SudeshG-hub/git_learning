CREATE TABLE [dbo].[DimCountry]
(
[Country_Key] [smallint] NOT NULL,
[CountryAlt_Key] [smallint] NOT NULL,
[Country2DigitCode] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Country3DigitCode] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CountryName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CountryShortName] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CountryShortNameEnum] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CountryGroup] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CountrySubGroup] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CountrySegment] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CountryValidCode] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CurrencyCode] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CIBIL_CountryCode] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MOODYRating] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SNPRating] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RegulatorCRAR] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SrcSysCountryCode] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SrcSysCountryName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DestSysCountryCode] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
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
