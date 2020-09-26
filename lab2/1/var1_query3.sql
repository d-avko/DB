use Company
go

select dep.Name as DepName, emp.BusinessEntityID, emp.JobTitle as 'Job Title', shift.ShiftID
from humanResources.EmployeeDepartmentHistory as depHistory
inner join humanResources.Employee as emp on emp.BusinessEntityID = depHistory.BusinessEntityID
inner join humanResources.Department as dep on dep.DepartmentID = depHistory.DepartmentID
inner join humanResources.Shift as shift on shift.ShiftID = depHistory.ShiftID

order by CASE 
        WHEN dep.Name = 'Document Control' THEN shift.ShiftID
        ELSE emp.BusinessEntityID
   END