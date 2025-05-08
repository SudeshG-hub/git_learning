IF NOT EXISTS (SELECT * FROM master.dbo.syslogins WHERE loginname = N'D2KT\Zulqarnain.Shaikh')
CREATE LOGIN [D2KT\Zulqarnain.Shaikh] FROM WINDOWS
GO
CREATE USER [D2KT\Zulqarnain.Shaikh] FOR LOGIN [D2KT\Zulqarnain.Shaikh]
GO
