
/*
    Project: Societas
    File: 01_create_user_tables.sql
    Purpose: Create user, role, and user-role tables.
*/

USE Societas;
GO

-- 1. Users table
CREATE TABLE dbo.Users
(
    UserID INT IDENTITY(1,1) PRIMARY KEY,
    FullName NVARCHAR(100) NOT NULL,
    Email NVARCHAR(255) NOT NULL UNIQUE,
    PasswordHash NVARCHAR(255) NOT NULL,
    IsActive BIT NOT NULL
        CONSTRAINT DF_Users_IsActive DEFAULT (1),
    CreatedAt DATETIME2 NOT NULL
        CONSTRAINT DF_Users_CreatedAt DEFAULT (SYSDATETIME())
);
GO

-- 2. Roles table
CREATE TABLE dbo.Roles
(
    RoleID INT IDENTITY(1,1) PRIMARY KEY,
    RoleName NVARCHAR(50) NOT NULL UNIQUE,
    Description NVARCHAR(255) NULL
);
GO

-- 3. UserRoles table
CREATE TABLE dbo.UserRoles
(
    UserID INT NOT NULL,
    RoleID INT NOT NULL,
    AssignedAt DATETIME2 NOT NULL
        CONSTRAINT DF_UserRoles_AssignedAt DEFAULT (SYSDATETIME()),

    CONSTRAINT PK_UserRoles
        PRIMARY KEY (UserID, RoleID),

    CONSTRAINT FK_UserRoles_Users
        FOREIGN KEY (UserID)
        REFERENCES dbo.Users(UserID),

    CONSTRAINT FK_UserRoles_Roles
        FOREIGN KEY (RoleID)
        REFERENCES dbo.Roles(RoleID)
);
GO
