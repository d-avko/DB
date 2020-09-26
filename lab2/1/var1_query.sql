use Company
go

select emp.BusinessEntityID, emp.JobTitle, MAX(payHistory.Rate) as MaxRate
from humanResources.Employee as emp
left join humanResources.EmployeePayHistory as payHistory on payHistory.BusinessEntityID = emp.BusinessEntityID
group by emp.BusinessEntityID, emp.JobTitle 
order by MaxRate DESC
