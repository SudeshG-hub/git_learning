IF NOT EXISTS (SELECT * FROM master.dbo.syslogins WHERE loginname = N'D2KT\d2kuser')
CREATE LOGIN [D2KT\d2kuser] FROM WINDOWS
GO
CREATE USER [D2KT\d2kuser] FOR LOGIN [D2KT\d2kuser]
GO
