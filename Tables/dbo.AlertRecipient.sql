CREATE TABLE [dbo].[AlertRecipient]
(
[AlertId] [int] NOT NULL IDENTITY(1, 1),
[RecipientEmailIDs] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RecipientMobileNumber] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SourceType] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AlertType] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Recipient_CC_EmailIDs] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
