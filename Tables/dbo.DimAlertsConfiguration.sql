CREATE TABLE [dbo].[DimAlertsConfiguration]
(
[AlertId] [int] NOT NULL IDENTITY(1, 1),
[Email_Host] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Email_PORT] [int] NULL,
[Email_mailFrom] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AlertType] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SMSVersion] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SMSAppID] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SMSTopicName] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SMSCustomerID] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SMSAccountNo] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SMSStringContent] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SMSHost] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SMSEndPoint] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
