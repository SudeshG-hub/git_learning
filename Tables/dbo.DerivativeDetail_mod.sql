CREATE TABLE [dbo].[DerivativeDetail_mod]
(
[EntityKey] [bigint] NOT NULL,
[DerivativeEntityID] [int] NOT NULL,
[CustomerACID] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomerID] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomerName] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DerivativeRefNo] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Duedate] [date] NULL,
[DueAmt] [decimal] (16, 2) NULL,
[OsAmt] [decimal] (16, 2) NULL,
[POS] [decimal] (16, 2) NULL,
[AuthorisationStatus] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EffectiveFromTimeKey] [int] NOT NULL,
[EffectiveToTimeKey] [int] NOT NULL,
[CreatedBy] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateCreated] [smalldatetime] NULL,
[ModifiedBy] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateModified] [smalldatetime] NULL,
[ApprovedBy] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateApproved] [smalldatetime] NULL,
[Changefields] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[InstrumentName] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OverDueSinceDt] [date] NULL,
[DueAmtReceivable] [decimal] (18, 2) NULL,
[MTMIncomeAmt] [decimal] (18, 2) NULL,
[CouponDate] [date] NULL,
[CouponAmt] [decimal] (18, 2) NULL,
[CouponOverDueSinceDt] [date] NULL,
[OverdueCouponAmt] [decimal] (18, 2) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[DerivativeDetail_mod] ADD CONSTRAINT [CK__Derivativ__Effec__0DAFD807] CHECK (([EffectiveToTimeKey]=(49999)))
GO
ALTER TABLE [dbo].[DerivativeDetail_mod] ADD CONSTRAINT [CK__Derivativ__Effec__3B56A726] CHECK (([EffectiveToTimeKey]=(49999)))
GO
