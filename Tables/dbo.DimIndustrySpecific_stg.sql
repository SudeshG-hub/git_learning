CREATE TABLE [dbo].[DimIndustrySpecific_stg]
(
[Entity_Key] [int] NOT NULL IDENTITY(1, 1),
[SlNo] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CIF] [int] NULL,
[BSRActivityCode] [int] NULL,
[ProvisionRate] [decimal] (18, 2) NULL,
[filname] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SummaryID] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
