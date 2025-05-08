CREATE TABLE [dbo].[CustSecurityWorkFlow]
(
[EntityKey] [bigint] NOT NULL IDENTITY(1, 1),
[CustomerEntityId] [int] NULL,
[CollateralID] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CurrentValueSource] [decimal] (22, 2) NULL,
[CollateralExposure] [decimal] (22, 2) NULL,
[CollCustExposure] [decimal] (22, 2) NULL,
[PerColExpCustExp] [decimal] (18, 14) NULL,
[CustApprSecValue] [decimal] (22, 2) NULL,
[EffectiveFromTimeKey] [int] NOT NULL,
[EffectiveToTimeKey] [int] NOT NULL
) ON [PRIMARY]
GO
