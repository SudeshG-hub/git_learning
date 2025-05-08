CREATE TABLE [dbo].[DimBusinessRuleCol]
(
[BusinessRuleCol_Key] [int] NOT NULL IDENTITY(1, 1),
[BusinessRuleColAlt_Key] [int] NULL,
[BusinessRuleColDesc] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BusinessRuleColumn] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BusinessRuleColShortName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BusinessRuleColShortNameEnum] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BusinessRuleColGroup] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BusinessRuleColSubGroup] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BusinessRuleColSegment] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BusinessRuleColValidCode] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BusinessRuleColOrder_Key] [int] NULL,
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
