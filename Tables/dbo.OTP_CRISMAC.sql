CREATE TABLE [dbo].[OTP_CRISMAC]
(
[EntityKey] [int] NOT NULL IDENTITY(1, 1),
[USERId] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MobileNo] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EmailId] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OTP] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[StartTime] [time] NULL,
[EndTime] [time] NULL,
[EffectiveFromTimeKey] [int] NULL,
[EffectiveToTimeKey] [int] NULL,
[CreatedBy] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateCreated] [smalldatetime] NULL,
[ModifiedBy] [varchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateModified] [smalldatetime] NULL,
[ApprovedBy] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateApproved] [datetime] NULL,
[D2Ktimestamp] [timestamp] NOT NULL,
[LoginCount] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
