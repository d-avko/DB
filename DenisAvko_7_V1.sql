USE AdventureWorks2012;
GO

/*  Вывести значения полей [BusinessEntityID], [NationalIDNumber] и [JobTitle] 
из таблицы [HumanResources].[Employee] в виде xml, 
сохраненного в переменную. Формат xml должен соответствовать примеру: */

DECLARE @xml XML;

SET @xml = (
    SELECT
        e.BusinessEntityID '@ID',
        e.NationalIDNumber AS 'NationalIDNumber',
        e.JobTitle AS 'JobTitle'
    FROM
        HumanResources.Employee AS e 
    FOR XML
        PATH ('Employee'),
        ROOT ('Employees')
);

SELECT @xml;

/* Создать временную таблицу и заполнить её данными из переменной, содержащей xml. */

--drop table dbo.#Employee;

CREATE TABLE dbo.#Employee
(
    BusinessEntityID INT,
	NationalIDNumber nvarchar(50),
	JobTitle nvarchar(50)
);

INSERT INTO dbo.#Employee
SELECT
   MY_XML.Employee.value('@ID', 'INT') as BusinessEntityID,
   MY_XML.Employee.query('NationalIDNumber').value('.', 'VARCHAR(50)') as NationalIDNumber,
   MY_XML.Employee.query('JobTitle').value('.', 'VARCHAR(50)') as JobTitle
FROM @xml.nodes('Employees/Employee') AS MY_XML (Employee)

SELECT * FROM dbo.#Employee;