
/*
    Project: Societas
    File: create_database.sql
    Purpose: Create the project database if it does not exist.
*/

USE master;
GO

IF DB_ID(N'Societas') IS NULL
BEGIN
    CREATE DATABASE Societas;
    PRINT N'Societas database created successfully.';
END
ELSE
BEGIN
    PRINT N'Societas database already exists.';
END;
GO