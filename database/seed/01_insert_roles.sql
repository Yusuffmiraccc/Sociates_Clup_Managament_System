
/*
    Project: Societas
    File: 01_insert_roles.sql
    Purpose: Insert the initial system roles.
*/

USE Societas;
GO

-- 1. Student Affairs Coordinator
IF NOT EXISTS (
    SELECT 1
    FROM dbo.Roles
    WHERE RoleName = N'Student Affairs Coordinator'
)
BEGIN
    INSERT INTO dbo.Roles (RoleName, Description)
    VALUES (
        N'Student Affairs Coordinator',
        N'Manages clubs, event applications, halls, and equipment allocations.'
    );
END;
GO

-- 2. Club Representative
IF NOT EXISTS (
    SELECT 1
    FROM dbo.Roles
    WHERE RoleName = N'Club Representative'
)
BEGIN
    INSERT INTO dbo.Roles (RoleName, Description)
    VALUES (
        N'Club Representative',
        N'Manages club event applications, collaboration requests, and participants.'
    );
END;
GO

-- 3. Financial Officer
IF NOT EXISTS (
    SELECT 1
    FROM dbo.Roles
    WHERE RoleName = N'Financial Officer'
)
BEGIN
    INSERT INTO dbo.Roles (RoleName, Description)
    VALUES (
        N'Financial Officer',
        N'Manages club budgets, expense requests, and payment records.'
    );
END;
GO

-- Verify the inserted roles
SELECT RoleID, RoleName, Description
FROM dbo.Roles
ORDER BY RoleID;
GO
