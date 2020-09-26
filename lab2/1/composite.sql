use Company
go

select emp.BusinessEntityID, emp.JobTitle, MAX(payHistory.Rate) as MaxRate
from humanResources.Employee as emp
left join humanResources.EmployeePayHistory as payHistory on payHistory.BusinessEntityID = emp.BusinessEntityID
group by emp.BusinessEntityID, emp.JobTitle 
order by MaxRate DESC

select emp.BusinessEntityID, emp.JobTitle, payHistory.Rate as Rate,
DENSE_RANK() OVER (ORDER BY 
	CASE 
        WHEN payHistory.Rate IS NULL THEN 1
        ELSE 0
   END, payHistory.Rate) AS RankRate
from humanResources.Employee as emp
left join humanResources.EmployeePayHistory as payHistory on payHistory.BusinessEntityID = emp.BusinessEntityID

select dep.Name as DepName, emp.BusinessEntityID, emp.JobTitle as 'Job Title', shift.ShiftID
from humanResources.EmployeeDepartmentHistory as depHistory
inner join humanResources.Employee as emp on emp.BusinessEntityID = depHistory.BusinessEntityID
inner join humanResources.Department as dep on dep.DepartmentID = depHistory.DepartmentID
inner join humanResources.Shift as shift on shift.ShiftID = depHistory.ShiftID

order by CASE 
        WHEN dep.Name = 'Document Control' THEN shift.ShiftID
        ELSE emp.BusinessEntityID
   END