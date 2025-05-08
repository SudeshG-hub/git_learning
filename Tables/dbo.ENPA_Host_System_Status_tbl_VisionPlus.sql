CREATE TABLE [dbo].[ENPA_Host_System_Status_tbl_VisionPlus]
(
[Account_No] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Host_System_Name] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Main_Classification] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Report_Date] [date] NULL,
[Remarks] [varchar] (1500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Closed_Date] [date] NULL,
[Create_On] [datetime] NULL
) ON [PRIMARY]
GO
