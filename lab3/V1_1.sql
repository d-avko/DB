use AdventureWorks2012;
Go
--добавьте в таблицу dbo.Person поле FullName типа nvarchar размерностью 100 символов
ALTER TABLE dbo.Person
ADD FullName nvarchar(100);

Go

/*
объявите табличную переменную с такой же структурой как dbo.Person и заполните ее данными из dbo.Person. 
Поле Title заполните на основании данных из поля Gender таблицы HumanResources.Employee, 
если gender=M тогда Title=’Mr.’, если gender=F тогда Title=’Ms.’
*/

DECLARE @tempPerson table (
BusinessEntityID int primary key,
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


insert into @tempPerson (
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
	CASE
    WHEN emp.Gender = 'M' THEN 'Mr.'
    WHEN emp.Gender = 'F' THEN 'Ms.'
    ELSE 'No title.'
	END AS Title,
	person.FirstName,
	person.MiddleName,
	person.LastName,
	person.Suffix,
	person.EmailPromotion,
	person.ModifiedDate
from dbo.Person as person
inner join humanResources.Employee as emp on emp.BusinessEntityID = person.BusinessEntityID

/*
обновите поле FullName в dbo.Person данными из табличной переменной, 
объединив информацию из полей Title, FirstName, LastName (например ‘Mr. Jossef Goldberg’)
*/

UPDATE dbo.Person
SET 
FullName = CONCAT(tempVar.Title, ' ', tempVar.FirstName, ' ', tempVar.LastName)
FROM
dbo.Person person
inner join @tempPerson as tempVar on tempVar.BusinessEntityID = person.BusinessEntityID

Go

/*
удалите данные из dbo.Person, где количество символов в поле FullName превысило 20 символов
*/

delete from dbo.Person
where LEN(dbo.Person.FullName) > 20;

Go

/*
удалите все созданные ограничения и значения по умолчанию. После этого, удалите поле ID
*/

DECLARE @sql NVARCHAR(MAX) = N'';

SELECT  @sql += N'ALTER TABLE ' + 'dbo' + '.[' + 'Person' + '] DROP CONSTRAINT ' + constraints.CONSTRAINT_NAME + ';'
FROM AdventureWorks2012.INFORMATION_SCHEMA.CONSTRAINT_TABLE_USAGE as constraints
WHERE TABLE_SCHEMA = 'dbo' AND TABLE_NAME = 'Person';

print(@sql)
execute(@sql)

alter table dbo.Person
drop column ID;

Go

/*удалите таблицу dbo.Person*/

drop table dbo.Person


