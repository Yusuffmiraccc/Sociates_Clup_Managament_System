
/*
    Project: Societas
    File: 02_create_club_tables.sql
    Purpose: Create clubs and club membership tables.
*/

USE Societas;
GO

-- 1. Clubs table
CREATE TABLE dbo.Clubs
(
    ClubID INT IDENTITY(1,1) PRIMARY KEY,
    ClubName NVARCHAR(150) NOT NULL UNIQUE,
    Description NVARCHAR(500) NULL,
    IsActive BIT NOT NULL
        CONSTRAINT DF_Clubs_IsActive DEFAULT (1),
    CreatedAt DATETIME2 NOT NULL
        CONSTRAINT DF_Clubs_CreatedAt DEFAULT (SYSDATETIME())
);
GO

-- 2. ClubMemberships table
CREATE TABLE dbo.ClubMemberships
(
    ClubID INT NOT NULL,
    UserID INT NOT NULL,

    MembershipType NVARCHAR(30) NOT NULL
        CONSTRAINT DF_ClubMemberships_MembershipType
        DEFAULT (N'Member'),

    JoinedAt DATETIME2 NOT NULL
        CONSTRAINT DF_ClubMemberships_JoinedAt
        DEFAULT (SYSDATETIME()),

    IsActive BIT NOT NULL
        CONSTRAINT DF_ClubMemberships_IsActive
        DEFAULT (1),

    CONSTRAINT PK_ClubMemberships
        PRIMARY KEY (ClubID, UserID),

    CONSTRAINT FK_ClubMemberships_Clubs
        FOREIGN KEY (ClubID)
        REFERENCES dbo.Clubs(ClubID),

    CONSTRAINT FK_ClubMemberships_Users
        FOREIGN KEY (UserID)
        REFERENCES dbo.Users(UserID),

    CONSTRAINT CK_ClubMemberships_MembershipType
        CHECK (MembershipType IN
            (N'Member', N'Representative'))
);
GO
