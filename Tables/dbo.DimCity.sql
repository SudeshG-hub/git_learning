CREATE TABLE [dbo].[DimCity]
(
[City_Key] [smallint] NOT NULL,
[CityAlt_Key] [smallint] NOT NULL,
[CityName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CityShortName] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CityShortNameEnum] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CityGroup] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CitySubGroup] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CitySegment] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CityValidCode] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DistrictAlt_Key] [smallint] NULL,
[DistrictName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SrcSysCityCode] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SrcSysCityName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DestSysCityCode] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
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
