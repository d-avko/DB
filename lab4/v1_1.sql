USE AdventureWorks2012;
GO

/*
 Создайте таблицу Production.ProductCategoryHst, 
 которая будет хранить информацию об изменениях в таблице Production.ProductCategory.
*/

create table Production.ProductCategoryHst(
	ID INT IDENTITY(1, 1) PRIMARY KEY,
	Action CHAR(6) NOT NULL CHECK (Action IN('INSERT', 'UPDATE', 'DELETE')),
	ModifiedDate DATETIME NOT NULL DEFAULT GETDATE(),
	SourceID INT NOT NULL,
	UserName VARCHAR(50) NOT NULL
);

GO
/*

Создайте один AFTER триггер для трех операций INSERT, UPDATE, DELETE для таблицы Production.ProductCategory. 
Триггер должен заполнять таблицу Production.ProductCategoryHst с указанием типа операции 
в поле Action в зависимости от оператора, вызвавшего триггер.
*/

CREATE TRIGGER Production.ProductCategory_Insert_Update_Delete
ON Production.ProductCategory
AFTER UPDATE, INSERT, DELETE AS
	if exists(SELECT * from inserted) and exists (SELECT * from deleted)
	begin
		INSERT INTO Production.ProductCategoryHst(Action, ModifiedDate, SourceID, UserName)
		SELECT 'UPDATE', GETDATE(), upd.ProductCategoryID, USER_NAME()
		FROM inserted AS upd;
	end

	If exists (Select * from inserted) and not exists(Select * from deleted)
	begin
		INSERT INTO Production.ProductCategoryHst(Action, ModifiedDate, SourceID, UserName)
		SELECT 'INSERT', GETDATE(), ins.ProductCategoryID, USER_NAME()
		FROM inserted AS ins;
	end

	If exists(select * from deleted) and not exists(Select * from inserted)
	begin 
		INSERT INTO Production.ProductCategoryHst(Action, ModifiedDate, SourceID, UserName)
		SELECT 'DELETE', GETDATE(), del.ProductCategoryID, USER_NAME()
		FROM deleted AS del;
	end

GO

/*
Создайте представление VIEW, отображающее все поля таблицы Production.ProductCategory.
*/

CREATE VIEW Production.vProductCategory
WITH ENCRYPTION
AS 
	SELECT * FROM Production.ProductCategory;
GO

/*
Вставьте новую строку в Production.ProductCategory через представление. 
Обновите вставленную строку. 
Удалите вставленную строку. 
Убедитесь, что все три операции отображены в Production.ProductCategoryHst.
*/

INSERT INTO Production.vProductCategory (
	Name, 
	rowguid, 
	ModifiedDate)
VALUES ('Electronic devices', NEWID(), GetDate());

GO

UPDATE Production.vProductCategory SET Name = 'Mobile devices' WHERE Name = 'Electronic devices';

GO

DELETE Production.vProductCategory WHERE Name = 'Mobile devices';

GO

SELECT * 
FROM Production.ProductCategoryHst;