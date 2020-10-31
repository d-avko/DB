USE AdventureWorks2012;
GO

/*  Создайте scalar-valued функцию, которая будет принимать 
в качестве входного параметра имя группы отделов (HumanResources.Department.GroupName) 
и возвращать количество отделов, входящих в эту группу. */

CREATE FUNCTION HumanResources.GetDepartmentsCountByGroupName(@GroupName NVARCHAR(50)) 
RETURNS INT AS
BEGIN
	DECLARE @returnvalue INT;
	select @returnvalue = COUNT(*) from HumanResources.Department as dep where dep.GroupName = @GroupName;

	RETURN(@returnvalue);
END;
GO

SELECT HumanResources.GetDepartmentsCountByGroupName ('Research and Development');
GO

/*  Создайте inline table-valued функцию, которая будет принимать в качестве входного параметра id отдела 
(HumanResources.Department.DepartmentID), 
а возвращать 3 самых старших сотрудника, которые начали работать в отделе с 2005 года. */

CREATE FUNCTION HumanResources.Get3OldestEmployees(@DepartmentID INT) 
RETURNS TABLE AS
RETURN
(
	select top(3) e.*
	from HumanResources.Employee as e
	inner join HumanResources.EmployeeDepartmentHistory as history on e.BusinessEntityID = history.BusinessEntityID
	where (history.DepartmentID = @DepartmentID) and (YEAR(history.StartDate) = 2005)
	order by e.BirthDate
);
GO

/*drop function HumanResources.GetOldestEmployee;*/

select * from HumanResources.Get3OldestEmployees(4);

/*  Вызовите функцию для каждого отдела, применив оператор CROSS APPLY. 
	Вызовите функцию для каждого отдела, применив оператор OUTER APPLY. */

SELECT * FROM HumanResources.Department as dep CROSS APPLY HumanResources.Get3OldestEmployees(dep.DepartmentID);
SELECT * FROM HumanResources.Department as dep OUTER APPLY HumanResources.Get3OldestEmployees(dep.DepartmentID);
GO

/* Измените созданную inline table-valued функцию, сделав ее multistatement table-valued 
(предварительно сохранив для проверки код создания inline table-valued функции). */

DROP FUNCTION HumanResources.Get3OldestEmployees;
GO

CREATE FUNCTION HumanResources.Get3OldestEmployees(@DepartmentID INT) 
RETURNS @result TABLE (
	[BusinessEntityID] [int] NOT NULL,
	[NationalIDNumber] [nvarchar](15) NOT NULL,
	[LoginID] [nvarchar](256) NOT NULL,
	[OrganizationNode] [hierarchyid] NULL,
	[OrganizationLevel]  [smallint] NULL,
	[JobTitle] [nvarchar](50) NOT NULL,
	[BirthDate] [date] NOT NULL,
	[MaritalStatus] [nchar](1) NOT NULL,
	[Gender] [nchar](1) NOT NULL,
	[HireDate] [date] NOT NULL,
	[SalariedFlag] [dbo].[Flag] NOT NULL,
	[VacationHours] [smallint] NOT NULL,
	[SickLeaveHours] [smallint] NOT NULL,
	[CurrentFlag] [dbo].[Flag] NOT NULL,
	[rowguid] [uniqueidentifier] ROWGUIDCOL  NOT NULL,
	[ModifiedDate] [datetime] NOT NULL) AS 
BEGIN
	INSERT INTO @result
	SELECT top(3)
		e.BusinessEntityID,
		e.NationalIDNumber,
		e.LoginID,
		e.OrganizationNode,
		e.OrganizationLevel,
		e.JobTitle,
		e.BirthDate,
		e.MaritalStatus,
		e.Gender,
		e.HireDate,
		e.SalariedFlag,
		e.VacationHours,
		e.SickLeaveHours,
		e.CurrentFlag,
		e.rowguid,
		e.ModifiedDate
	from HumanResources.Employee as e
	inner join HumanResources.EmployeeDepartmentHistory as history on e.BusinessEntityID = history.BusinessEntityID
	where (history.DepartmentID = @DepartmentID) and (YEAR(history.StartDate) = 2005)
	order by e.BirthDate
	RETURN
END;
GO

SELECT * FROM HumanResources.Get3OldestEmployees(4)
GO