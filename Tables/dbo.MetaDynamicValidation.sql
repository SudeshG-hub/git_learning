CREATE TABLE [dbo].[MetaDynamicValidation]
(
[Entitykey] [smallint] NOT NULL IDENTITY(1, 1),
[ValidationGrpKey] [int] NULL,
[ValidationKey] [int] NULL,
[ControlID] [int] NULL,
[CurrExpectedValue] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CurrExpectedKey] [int] NULL,
[ExpControlID] [varchar] (300) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ExpKey] [int] NULL,
[ExpControlValue] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Operator] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Message] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
