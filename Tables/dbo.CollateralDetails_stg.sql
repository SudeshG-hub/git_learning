CREATE TABLE [dbo].[CollateralDetails_stg]
(
[Entity_Key] [int] NOT NULL IDENTITY(1, 1),
[SrNo] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AccountID] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CollateralType] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CollateralSubType] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ChargeType] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ChargeNature] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ValuationDate] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CurrentCollateralValueinRs] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ExpiryBusinessRule] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[filname] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
