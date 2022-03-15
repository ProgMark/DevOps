WORKFLOW
1) DELETE DATA FROM TEMP TABLES
2) ANSIBLE TRIGGER LOAD DB FILES ( BULK vs DB to DB ??? )
3) ANSIBLE TRIGGER LOAD DIRECTORY FILES
4) ANSIBLE TRIGGER COMPARISON
5) ANSIBLE GET FILES TO DELETE 
6) ANSIBLE TRIGGER DELETE FILES ( TRANSACTION FILE WITH DB ) ( ERROR ??? )

CREATE DATABASE AttachmentsMaintenance
GO

USE AttachmentsMaintenance
GO

CREATE TABLE [dbo].[DbFiles] ([Name] [uniqueidentifier] NOT NULL
  CONSTRAINT [PK_DbFiles] PRIMARY KEY CLUSTERED
  (
  [Name] ASC
  ) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[DirectoryFiles] ([Name] [uniqueidentifier] NOT NULL
  CONSTRAINT [PK_DirectoryFiles] PRIMARY KEY CLUSTERED
  (
  [Name] ASC
  ) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[FilesToDelete] ([Name] [uniqueidentifier] NOT NULL
  CONSTRAINT [PK_FilesToDelete] PRIMARY KEY CLUSTERED
  (
  [Name] ASC
  ) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

USE AttachmentsMaintenance
GO
BULK INSERT [dbo].[DbFiles]
FROM 'C:\Users\Dev\Desktop\TestFile\DbFiles.csv'
WITH
(
        FORMAT='CSV',
		FIELDTERMINATOR ='|',
		ROWTERMINATOR ='\n',
		FIRSTROW=2
)
GO

USE AttachmentsMaintenance
GO
BULK INSERT [dbo].[DirectoryFiles]
FROM 'C:\Users\Dev\Desktop\TestFile\FolderFiles.csv'
WITH
(
        FORMAT='CSV',
		FIELDTERMINATOR ='|',
		ROWTERMINATOR ='\n',
		FIRSTROW=2
)
GO


USE AttachmentsMaintenance
GO

INSERT INTO [dbo].[FilesToDelete] ( Name )
Select [dbo].[DirectoryFiles].[Name] From [dbo].[DirectoryFiles]
LEFT JOIN  [dbo].[DbFiles]
ON [dbo].[DbFiles].[Name] = [dbo].[DirectoryFiles].[Name]
WHERE [dbo].[DbFiles].[Name] IS NULL

---
SELECT TOP (1000) [Name]
  FROM [AttachmentsMaintenance].[dbo].[DbFiles]
  
SELECT TOP (1000) [Name]
  FROM [AttachmentsMaintenance].[dbo].[DirectoryFiles]
  
SELECT TOP (1000) [Name]
  FROM [AttachmentsMaintenance].[dbo].[FilesToDelete]
  


