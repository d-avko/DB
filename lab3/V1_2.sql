use AdventureWorks2012
go

/*
выполните код, созданный во втором задании второй лабораторной работы. Добавьте в таблицу dbo.Person поля 
SalesYTD MONEY, SalesLastYear MONEY и OrdersNum INT. 
Также создайте в таблице вычисляемое поле SalesDiff, считающее разницу значений в полях SalesYTD и SalesLastYear
*/

alter table dbo.Person
add SalesYTD money; 

Go

alter table dbo.Person
add SalesLastYear money; 

Go

alter table dbo.Person
add OrdersNum int; 

Go

alter table dbo.Person
add SalesDiff as SalesYTD - SalesLastYear; 

/*
создайте временную таблицу #Person, с первичным ключом по полю BusinessEntityID. 
Временная таблица должна включать все поля таблицы dbo.Person за исключением поля SalesDiff
*/

create table #Person(
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
ModifiedDate datetime,
SalesYTD money,
SalesLastYear money,
OrdersNum int
);

Go

/*
заполните временную таблицу данными из dbo.Person. Поля SalesYTD и SalesLastYear
заполните значениями из таблицы Sales.SalesPerson. Посчитайте количество заказов, 
оформленных каждым продавцом (SalesPersonID) в таблице Sales.SalesOrderHeader и заполните этими значениями поле OrdersNum. 
Подсчет количества заказов осуществите в Common Table Expression (CTE)
*/
WITH Sales_CTE (SalesPersonID, OrderNum)  
AS  
(  
    SELECT SalesPersonID, COUNT(*) as OrderNum  
    FROM Sales.SalesOrderHeader  
    WHERE SalesPersonID IS NOT NULL 
	group by SalesPersonID
) 
insert into #Person (
	BusinessEntityID,
	PersonType,
	NameStyle,
	Title,
	FirstName,
	MiddleName,
	LastName,
	Suffix,
	EmailPromotion,
	ModifiedDate,
	SalesYTD,
	SalesLastYear,
	OrdersNum)

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
	person.ModifiedDate,
	sperson.SalesYTD,
	sperson.SalesLastYear,
	cte.OrderNum as OrdersNum
from dbo.Person as person
left join Sales.SalesPerson as sperson on sperson.BusinessEntityID = person.BusinessEntityID
left join Sales_CTE as cte on cte.SalesPersonID = person.BusinessEntityID


/*
удалите из таблицы dbo.Person одну строку (где BusinessEntityID = 290)
*/

delete from dbo.Person
where dbo.Person.BusinessEntityID = 290

MERGE dbo.Person AS t_target
USING #Person AS t_source
ON t_target.BusinessEntityID = t_source.BusinessEntityID
WHEN MATCHED THEN UPDATE SET	
	t_target.SalesYTD = t_source.SalesYTD,
	t_target.SalesLastYear = t_source.SalesLastYear,
	t_target.OrdersNum = t_source.OrdersNum
WHEN NOT MATCHED BY TARGET THEN	INSERT 
(
	BusinessEntityID,
	PersonType,
	NameStyle,
	Title,
	FirstName,
	MiddleName,
	LastName,
	Suffix,
	EmailPromotion,
	ModifiedDate,
	SalesYTD,
	SalesLastYear,
	OrdersNum
)
VALUES
(
	t_source.BusinessEntityID, 
	t_source.PersonType, 
	t_source.NameStyle,
	t_source.Title,
	t_source.FirstName,
	t_source.MiddleName,
	t_source.LastName,
	t_source.Suffix,
	t_source.EmailPromotion,
	t_source.ModifiedDate,
	t_source.SalesYTD,
	t_source.SalesLastYear,
	t_source.OrdersNum
)
WHEN NOT MATCHED BY SOURCE THEN DELETE;
