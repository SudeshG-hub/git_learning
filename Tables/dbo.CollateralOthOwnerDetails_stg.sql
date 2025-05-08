CREATE TABLE [dbo].[CollateralOthOwnerDetails_stg]
(
[Entity_Key] [int] NOT NULL IDENTITY(1, 1),
[SrNo] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SystemCollateralID] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomeroftheBank] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomerID] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OtherOwnerName] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OtherOwnerRelationship] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Ifrelativeentervalue] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AddressType] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AddressCategory] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AddressLine1] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AddressLine2] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AddressLine3] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[City] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PinCode] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Country] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[District] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[StdCodeO] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PhoneNoO] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[StdCodeR] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PhoneNoR] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MobileNo] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[filname] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
