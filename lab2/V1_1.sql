use AdventureWorks2012
go

--Вывести на экран список сотрудников с указанием максимальной ставки, по которой им выплачивали денежные средства.

select emp.BusinessEntityID, emp.JobTitle, MAX(payHistory.Rate) as MaxRate
from humanResources.Employee as emp
left join humanResources.EmployeePayHistory as payHistory on payHistory.BusinessEntityID = emp.BusinessEntityID
group by emp.BusinessEntityID, emp.JobTitle 
order by MaxRate DESC

/*
Разбить все почасовые ставки на группы таким образом, чтобы одинаковые ставки входили в одну группу. 
Номера групп должны быть распределены по возрастанию ставок. Назовите столбец [RankRate].
*/

select emp.BusinessEntityID, emp.JobTitle, payHistory.Rate as Rate,
DENSE_RANK() OVER (ORDER BY 
	CASE 
        WHEN payHistory.Rate IS NULL THEN 1
        ELSE 0
   END, payHistory.Rate) AS RankRate
from humanResources.Employee as emp
left join humanResources.EmployeePayHistory as payHistory on payHistory.BusinessEntityID = emp.BusinessEntityID

/*
Вывести на экран информацию об отделах и работающих в них сотрудниках, отсортированную по полю ShiftID 
в отделе ‘Document Control’ и по полю BusinessEntityID во всех остальных отделах
*/

select dep.Name as DepName, emp.BusinessEntityID, emp.JobTitle as 'Job Title', shift.ShiftID
from humanResources.EmployeeDepartmentHistory as depHistory
inner join humanResources.Employee as emp on emp.BusinessEntityID = depHistory.BusinessEntityID
inner join humanResources.Department as dep on dep.DepartmentID = depHistory.DepartmentID
inner join humanResources.Shift as shift on shift.ShiftID = depHistory.ShiftID

order by CASE 
        WHEN dep.Name = 'Document Control' THEN shift.ShiftID
        ELSE emp.BusinessEntityID
   END