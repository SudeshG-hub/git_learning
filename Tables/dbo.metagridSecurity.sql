CREATE TABLE [dbo].[metagridSecurity]
(
[Date_of_Data] [date] NULL,
[Source_System_Name] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Customer_ID] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Account_ID] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Security_ID] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Collateral_Type] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Security_Code] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Charge_Type_Code] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Security_Value] [decimal] (16, 2) NULL,
[Valuation_Source] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Valuation_date] [date] NULL,
[Valuation_expiry_date] [date] NULL,
[AuthorisationStatus] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EffectiveFromTimeKey] [int] NULL,
[EffectiveToTimeKey] [int] NULL,
[CreatedBy] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateCreated] [smalldatetime] NULL,
[ModifiedBy] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateModified] [smalldatetime] NULL,
[ApprovedBy] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateApproved] [smalldatetime] NULL,
[EntityKey] [int] NOT NULL IDENTITY(1, 1),
[MetagridEntityId] [int] NULL
) ON [PRIMARY]
GO
