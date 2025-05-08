CREATE TABLE [dbo].[mst_SavedQuery]
(
[Id] [int] NOT NULL IDENTITY(1, 1),
[QueryName] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[QueryValue] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Description] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Tags] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Author] [nvarchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreatedDate] [datetime] NULL,
[Deleted] [bit] NULL CONSTRAINT [DF__mst_Saved__Delet__0BC78F95] DEFAULT ((0)),
[DeletedDate] [datetime] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[mst_SavedQuery] ADD CONSTRAINT [PK__mst_Save__3214EC0713AB4832] PRIMARY KEY CLUSTERED ([Id]) ON [PRIMARY]
GO
