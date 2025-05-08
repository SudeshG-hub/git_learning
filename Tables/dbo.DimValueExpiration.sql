CREATE TABLE [dbo].[DimValueExpiration]
(
[EntityKey] [int] NOT NULL IDENTITY(1, 1),
[ValueExpirationAltKey] [int] NULL,
[SecurityTypeAlt_Key] [int] NULL,
[SecuritySubTypeAlt_Key] [int] NULL,
[Documents] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Validitycriteria] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ExpirationPeriod] [int] NULL,
[EffectiveFromTimeKey] [int] NULL,
[EffectiveToTimeKey] [int] NULL,
[AuthorisationStatus] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreatedBy] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateCreated] [smalldatetime] NULL,
[ModifiedBy] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateModified] [smalldatetime] NULL,
[ApprovedBy] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateApproved] [smalldatetime] NULL
) ON [PRIMARY]
GO
