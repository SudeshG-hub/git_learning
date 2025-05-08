CREATE TABLE [dbo].[AssetClassValidationData]
(
[ROW] [bigint] NULL,
[CustomerID] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AssetClassOrg] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AssetClassUpload] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
