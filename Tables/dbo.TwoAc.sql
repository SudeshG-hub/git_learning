CREATE TABLE [dbo].[TwoAc]
(
[ACID] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Amount] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Date] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Action] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[filname] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SrNo] [int] NULL,
[ErrorMessage] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ErrorinColumn] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Srnooferroneousrows] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
