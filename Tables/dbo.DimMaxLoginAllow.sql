CREATE TABLE [dbo].[DimMaxLoginAllow]
(
[EntityKey] [smallint] NOT NULL,
[UserLocationCode] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UserLocation] [varchar] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UserLocationName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MaxUserLogin] [smallint] NULL,
[UserLoginCount] [smallint] NULL,
[MaxUserCustom] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
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
