CREATE TABLE [dbo].[metagridcustomermaster]
(
[Date_of_Data] [date] NULL,
[Source_System] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UCIC_ID] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Customer_ID] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Customer_Name] [varchar] (300) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Customer_Constitution] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Gender] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Customer_Segment_Code] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PAN_No] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Asset_Class] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NPA_Date] [date] NULL,
[DBT_LOS_Date] [date] NULL,
[Always_NPA] [smallint] NULL,
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
