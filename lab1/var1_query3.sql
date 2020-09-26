use Company
go

select emp.BusinessEntityID, emp.JobTitle as 'Job Title', emp.MaritalStatus, emp.Gender, emp.BirthDate, emp.HireDate
from humanResources.Employee as emp
where (emp.MaritalStatus = 'M') and (YEAR(emp.HireDate) = 2004)
order by emp.BirthDate
OFFSET 0 ROWS
FETCH NEXT 5 ROWS ONLY