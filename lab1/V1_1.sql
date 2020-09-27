CREATE DATABASE Denis_Avko;
Go

USE Denis_Avko;
GO

CREATE SCHEMA sales;
GO

CREATE SCHEMA persons;
GO

CREATE TABLE sales.Orders (OrderNum INT NULL);

BACKUP DATABASE Denis_Avko
TO DISK = 'C:\Users\Denni\Desktop\Study\4 курс\1 сем\БД\lab1\Denis_Avko.bak';

USE master
GO 

DROP DATABASE Denis_Avko;

RESTORE DATABASE Denis_Avko
FROM DISK = 'C:\Users\Denni\Desktop\Study\4 курс\1 сем\БД\lab1\Denis_Avko.bak';

USE Denis_Avko
GO