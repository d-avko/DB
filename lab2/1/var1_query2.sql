use Company
go

select emp.BusinessEntityID, emp.JobTitle, payHistory.Rate as Rate,
DENSE_RANK() OVER (ORDER BY 
	CASE 
        WHEN payHistory.Rate IS NULL THEN 1
        ELSE 0
   END, payHistory.Rate) AS RankRate
from humanResources.Employee as emp
left join humanResources.EmployeePayHistory as payHistory on payHistory.BusinessEntityID = emp.BusinessEntityID
