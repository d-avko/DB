use Company
go

create table humanResources.Person(
BusinessEntityID int primary key identity,
PersonType varchar(64),
NameStyle varchar(64),
Title varchar(128),
FirstName varchar(128),
MiddleName varchar(128),
LastName varchar(128),
Suffix varchar(32),
EmailPromotion varchar(256),
AdditionalContactInfo varchar(1024),
Demographics varchar(256),
SickLeaveHours int,
ModifiedDate datetime,
rowguid uniqueidentifier
);

create table dbo.Person(
BusinessEntityID int,
PersonType varchar(64),
NameStyle varchar(64),
Title varchar(128),
FirstName varchar(128),
MiddleName varchar(128),
LastName varchar(128),
Suffix varchar(32),
EmailPromotion varchar(256),
AdditionalContactInfo varchar(1024),
Demographics varchar(256),
SickLeaveHours int,
ModifiedDate datetime
);