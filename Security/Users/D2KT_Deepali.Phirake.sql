IF NOT EXISTS (SELECT * FROM master.dbo.syslogins WHERE loginname = N'D2KT\Deepali.Phirake')
CREATE LOGIN [D2KT\Deepali.Phirake] FROM WINDOWS
GO
CREATE USER [D2KT\Deepali.Phirake] FOR LOGIN [D2KT\Deepali.Phirake]
GO
