CREATE TABLE [dbo].[EncryptedData]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[EncryptedCreditCard] [varbinary] (max) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[EncryptedData] ADD CONSTRAINT [PK__Encrypte__3214EC2715F8E710] PRIMARY KEY CLUSTERED ([ID]) ON [PRIMARY]
GO
