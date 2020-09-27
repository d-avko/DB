use AdventureWorks2012
go

/*
создайте таблицу dbo.Person с такой же структурой как Person.Person, 
кроме полей xml, uniqueidentifier, не включая индексы, ограничения и триггеры
*/

create table dbo.Person(
BusinessEntityID int,
PersonType nchar(2),
NameStyle bit,
Title varchar(8),
FirstName nvarchar(50),
MiddleName nvarchar(50),
LastName nvarchar(50),
Suffix nvarchar(10),
EmailPromotion int not null,
SickLeaveHours int,
ModifiedDate datetime
);

Go

/*
используя инструкцию ALTER TABLE, добавьте в таблицу dbo.Person новое поле ID, которое является первичным 
ключом типа bigint и имеет свойство identity. Начальное значение для поля identity задайте 10 и приращение задайте 10;
*/

ALTER TABLE dbo.Person
   ADD ID BIGINT IDENTITY(10,10)
       CONSTRAINT PK_Person PRIMARY KEY CLUSTERED
	   
Go

/*
используя инструкцию ALTER TABLE, создайте для таблицы dbo.Person 
ограничение для поля Title, чтобы заполнить его можно было только значениями ‘Mr.’ или ‘Ms.’;
*/
	   
ALTER TABLE dbo.Person
ADD CHECK (Title = 'Mr.' or  Title = 'Ms.');

Go

/*
используя инструкцию ALTER TABLE, создайте для таблицы dbo.Person 
ограничение DEFAULT для поля Suffix, задайте значение по умолчанию ‘N/A’;
*/

ALTER TABLE dbo.Person
ADD CONSTRAINT dv_Suffix
DEFAULT 'N/A' FOR Suffix;

Go

/*
заполните новую таблицу данными из Person.Person только для тех сотрудников, 
которые существуют в таблице HumanResources.Employee, исключив сотрудников из отдела ‘Executive’
*/

insert into dbo.Person (
	BusinessEntityID,
	PersonType,
	NameStyle,
	Title,
	FirstName,
	MiddleName,
	LastName,
	Suffix,
	EmailPromotion,
	ModifiedDate)
select 
	person.BusinessEntityID,
	person.PersonType,
	person.NameStyle,
	person.Title,
	person.FirstName,
	person.MiddleName,
	person.LastName,
	person.Suffix,
	person.EmailPromotion,
	person.ModifiedDate
from Person.Person as person
where person.BusinessEntityID in
	(select emp.BusinessEntityID
	from humanResources.EmployeeDepartmentHistory as history
	inner join humanResources.Employee as emp on emp.BusinessEntityID = history.BusinessEntityID
	inner join humanResources.Department as dep on dep.DepartmentID = history.DepartmentID
	where dep.Name != 'Executive')

Go

/*
 измените размерность поля Suffix, уменьшите размер поля до 5-ти символов
*/

ALTER TABLE dbo.Person
DROP CONSTRAINT dv_Suffix;

ALTER TABLE dbo.Person
ALTER COLUMN Suffix varchar(5);

ALTER TABLE dbo.Person
ADD CONSTRAINT dv_Suffix
DEFAULT 'N/A' FOR Suffix;

Go