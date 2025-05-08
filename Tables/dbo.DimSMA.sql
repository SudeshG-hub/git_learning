CREATE TABLE [dbo].[DimSMA]
(
[EntityKey] [int] NOT NULL IDENTITY(1, 1),
[SMAAlt_Key] [int] NULL,
[SourceAlt_Key] [int] NULL,
[CustomerACID] [varchar] (16) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomerId] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomerName] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ParameterNameAlt_Key] [int] NULL,
[ValueAlt_Key] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EffectiveFromTimeKey] [int] NULL,
[EffectiveToTimeKey] [int] NULL,
[AuthorisationStatus] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreatedBy] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateCreated] [datetime] NULL,
[ModifiedBy] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateModified] [datetime] NULL,
[ApprovedBy] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateApproved] [datetime] NULL
) ON [PRIMARY]
GO
