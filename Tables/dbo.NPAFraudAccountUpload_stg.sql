CREATE TABLE [dbo].[NPAFraudAccountUpload_stg]
(
[SrNo] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AccountNumber] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RFAreportedbyBank] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateofRFAreportingbyBank] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NameofotherBankreportingRFA] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateofreportingRFAbyOtherBank] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateofFraudoccurrence] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateofFrauddeclarationbyRBL] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NatureofFraud] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AreasofOperations] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Provisionpreference] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[filname] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
