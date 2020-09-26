use Company
Go

create table humanResources.Employee(
BusinessEntityID int PRIMARY KEY,
NationalIDNumber int,
LoginID int,
OrganizationalNode int,
OrganizationLevel int,
JobTitle varchar(1024),
BirthDate date,
MaritalStatus char,
Gender char,
HireDate date,
SalariedFlag bit,
VacationHours int,
SickLeaveHours int,
CurrentFlag bit,
rowguid UNIQUEIDENTIFIER,
ModifiedDate datetime
);

create table humanResources.JobCandidate(
JobCandidateID int PRIMARY KEY,
BusinessEntityID int,
Resume varchar(max),
ModifiedDate datetime,
FOREIGN KEY (BusinessEntityID) REFERENCES humanResources.Employee(BusinessEntityID)
);

create table humanResources.EmployeePayHistory(
BusinessEntityID int,
RateChangeDate date,
Rate decimal,
PayFrequency float,
ModifiedDate datetime,
FOREIGN KEY (BusinessEntityID) REFERENCES humanResources.Employee(BusinessEntityID),
primary key(BusinessEntityID, RateChangeDate)
);

create table humanResources.Department(
DepartmentID int PRIMARY KEY,
Name varchar(1024),
GroupName varchar(1024),
ModifiedDate datetime
);

create table humanResources.Shift(
ShiftID int PRIMARY KEY,
Name varchar(1024),
StartTime time(7),
EndTime time(7),
ModifiedDate datetime
);

create table humanResources.EmployeeDepartmentHistory(
BusinessEntityID int,
DepartmentID int,
ShiftID int,
StartDate date,
EndDate date,
ModifiedDate datetime,
FOREIGN KEY (BusinessEntityID) REFERENCES humanResources.Employee(BusinessEntityID),
FOREIGN KEY (DepartmentID) REFERENCES humanResources.Department(DepartmentID),
FOREIGN KEY (ShiftID) REFERENCES humanResources.Shift(ShiftID),
primary key(BusinessEntityID, DepartmentID, ShiftID, StartDate)
);