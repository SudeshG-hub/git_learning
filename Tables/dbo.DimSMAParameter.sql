CREATE TABLE [dbo].[DimSMAParameter]
(
[EntityKey] [int] NOT NULL IDENTITY(1, 1),
[SMAParameterAlt_Key] [int] NULL,
[ParameterName] [varchar] (5000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EffectiveFromTimeKey] [int] NULL,
[EffectiveToTimeKey] [int] NULL,
[CreatedBy] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateCreated] [datetime] NULL
) ON [PRIMARY]
GO
