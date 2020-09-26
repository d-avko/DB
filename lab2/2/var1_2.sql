use Company
go

ALTER TABLE dbo.Person
ADD CHECK (Title = 'Mr.' or  Title = 'Ms.');