CREATE TABLE [dbo].[UploadRPModuleLender]
(
[SrNo] [int] NULL,
[UCICID] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomerID] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BorrowerPAN] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BorrowerName] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LenderName] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[InDefaultDate] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OutofDefaultDate] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[filname] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ErrorMessage] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ErrorinColumn] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Srnooferroneousrows] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
