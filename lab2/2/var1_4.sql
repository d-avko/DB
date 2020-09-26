use Company
go

insert into dbo.Person (
	BusinessEntityID,
	PersonType,
	NameStyle,
	Title,
	FirstName,
	MiddleName,
	LastName,
	Suffix,
	EmailPromotion,
	AdditionalContactInfo,
	Demographics,
	SickLeaveHours,
	ModifiedDate)
select 
	person.BusinessEntityID,
	person.PersonType,
	person.NameStyle,
	person.Title,
	person.FirstName,
	person.MiddleName,
	person.LastName,
	person.Suffix,
	person.EmailPromotion,
	person.AdditionalContactInfo,
	person.Demographics,
	person.SickLeaveHours,
	person.ModifiedDate
from humanResources.Person as person
where person.BusinessEntityID in
	(select emp.BusinessEntityID
	from humanResources.EmployeeDepartmentHistory as history
	inner join humanResources.Employee as emp on emp.BusinessEntityID = history.BusinessEntityID
	inner join humanResources.Department as dep on dep.DepartmentID = history.DepartmentID
	where dep.Name != 'Executive')