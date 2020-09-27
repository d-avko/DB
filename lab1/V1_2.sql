use AdventureWorks2012
go

/*
Вывести на экран сотрудников, позиция которых находится в списке: 
‘Accounts Manager’,’Benefits Specialist’,’Engineering Manager’,
’Finance Manager’,’Maintenance Supervisor’,’Master Scheduler’,’Network Manager’. 
Выполните задание не используя оператор ‘=’.
*/

select emp.BusinessEntityID, emp.JobTitle as 'Job Title',  emp.Gender, emp.HireDate
from humanResources.Employee as emp
where emp.JobTitle in ( 'Accounts Manager',
'Benefits Specialist',
'Engineering Manager',
'Finance Manager',
'Maintenance Supervisor',
'Master Scheduler',
'Network Manager' )

Go

/*
Вывести на экран количество сотрудников, принятых на работу позже 2004 года (включая 2004 год).
*/

select COUNT(*) as EmpCount
from humanResources.Employee as emp
where YEAR (emp.HireDate) >= 2004

Go 

/*

Вывести на экран 5(пять) самых молодых сотрудников, состоящих в браке, которые были приняты на работу в 2004 году.

*/

select emp.BusinessEntityID, emp.JobTitle as 'Job Title', emp.MaritalStatus, emp.Gender, emp.BirthDate, emp.HireDate
from humanResources.Employee as emp
where (emp.MaritalStatus = 'M') and (YEAR(emp.HireDate) = 2004)
order by emp.BirthDate desc
OFFSET 0 ROWS
FETCH NEXT 5 ROWS ONLY