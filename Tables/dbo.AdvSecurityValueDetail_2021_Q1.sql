CREATE TABLE [dbo].[AdvSecurityValueDetail_2021_Q1]
(
[ENTITYKEY] [bigint] NULL,
[SecurityEntityID] [bigint] NOT NULL,
[ValuationSourceAlt_Key] [smallint] NULL,
[ValuationDate] [datetime] NULL,
[CurrentValue] [decimal] (16, 2) NULL,
[ValuationExpiryDate] [datetime] NULL,
[AuthorisationStatus] [char] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EffectiveFromTimeKey] [int] NOT NULL,
[EffectiveToTimeKey] [int] NOT NULL,
[CreatedBy] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateCreated] [smalldatetime] NULL,
[ModifiedBy] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateModified] [smalldatetime] NULL,
[ApprovedBy] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateApproved] [smalldatetime] NULL,
[D2Ktimestamp] [datetime] NULL,
[CurrentValueSource] [decimal] (18, 2) NULL,
[CollateralValueatthetimeoflastreviewinRs] [decimal] (18, 2) NULL,
[CollateralID] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ExpiryBusinessRule] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Periodinmonth] [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AdvSecurityValueDetail_2021_Q1] ADD CONSTRAINT [CK__AdvSecuri__Effec__0CBBB3CE] CHECK (([EffectiveToTimeKey]>(25933) AND [EffectiveToTimeKey]<=(26023)))
GO
ALTER TABLE [dbo].[AdvSecurityValueDetail_2021_Q1] ADD CONSTRAINT [AdvSecurityValueDetail_2021_Q1_AccountEntityID] PRIMARY KEY NONCLUSTERED ([SecurityEntityID], [EffectiveFromTimeKey], [EffectiveToTimeKey]) ON [PRIMARY]
GO
