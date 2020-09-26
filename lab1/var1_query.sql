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