use Company
go

select COUNT(*) as EmpCount
from humanResources.Employee as emp
where YEAR (emp.HireDate) >= 2004