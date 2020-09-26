use Company
go

ALTER TABLE dbo.Person
ADD CONSTRAINT dv_Suffix
DEFAULT 'N/A' FOR Suffix;