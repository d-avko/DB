use Company
go

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

select COUNT(*) as EmpCount
from humanResources.Employee as emp
where YEAR (emp.HireDate) >= 2004

Go 

select emp.BusinessEntityID, emp.JobTitle as 'Job Title', emp.MaritalStatus, emp.Gender, emp.BirthDate, emp.HireDate
from humanResources.Employee as emp
where (emp.MaritalStatus = 'M') and (YEAR(emp.HireDate) = 2004)
order by emp.BirthDate
OFFSET 0 ROWS
FETCH NEXT 5 ROWS ONLY