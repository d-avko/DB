USE AdventureWorks2012;
GO

/*
Создайте представление VIEW, отображающее данные из таблиц Production.ProductCategory и Production.ProductSubcategory. 
Сделайте невозможным просмотр исходного кода представления. 
Создайте уникальный кластерный индекс в представлении по полям ProductCategoryID, ProductSubcategoryID.
*/

CREATE VIEW Production.vCategorySubCategory(
	CategoryID,
	CategoryName,
	CategoryRowguid,
	CategoryModifiedDate,
	SubcategoryID,
	SubcategoryName,
	SubcategoryRowguid,
	SubcategoryModifiedDate
)
WITH SCHEMABINDING,
ENCRYPTION
AS
select
	category.ProductCategoryID as CategoryID,
	category.Name as CategoryName,
	category.rowguid as CategoryRowguid,
	category.ModifiedDate as CategoryModifiedDate,
	sub.ProductSubcategoryID as SubcategoryID,
	sub.Name as SubcategoryName,
	sub.rowguid as SubcategoryRowguid,
	sub.ModifiedDate as SubcategoryModifiedDate
from Production.ProductCategory as category
inner join Production.ProductSubcategory as sub on sub.ProductCategoryID = category.ProductCategoryID

GO

CREATE UNIQUE CLUSTERED INDEX IX_vCategorySubCategory_ProductCategoryID_ProductSubcategoryID
ON Production.vCategorySubCategory (CategoryID, SubcategoryID);
GO

/*
Создайте три INSTEAD OF триггера для представления на операции INSERT, UPDATE, DELETE. 
Каждый триггер должен выполнять соответствующие операции в таблицах 
Production.ProductCategory и Production.ProductSubcategory.

*/

CREATE TRIGGER Production.Trg_vCategorySubCategory_Insert ON Production.vCategorySubCategory
INSTEAD OF INSERT AS
BEGIN

	INSERT INTO Production.ProductCategory(
		Name,
		rowguid,
		ModifiedDate)
	SELECT 
		Name = ins.CategoryName,
		rowguid = ins.CategoryRowguid,
		ModifiedDate = GETDATE()
	FROM inserted AS ins;

	INSERT INTO Production.ProductSubcategory(
		ProductCategoryID,
		Name,
		rowguid,
		ModifiedDate)
	SELECT 
		ProductCategoryID = category.ProductCategoryID,
		Name = ins.SubcategoryName,
		rowguid = NEWID(),
		ModifiedDate = GETDATE()
	FROM inserted AS ins
	JOIN Production.ProductCategory AS category 
		ON category.rowguid = ins.CategoryRowguid
END;
GO

CREATE TRIGGER Production.Trg_vCategorySubCategory_Update ON Production.vCategorySubCategory
INSTEAD OF UPDATE AS
BEGIN
		UPDATE	Production.ProductCategory  SET
				Name = ins.CategoryName,
				ModifiedDate = GETDATE()
		FROM inserted AS ins
		WHERE ins.CategoryID = Production.ProductCategory.ProductCategoryID

		UPDATE	Production.ProductSubcategory  SET
				Name = ins.SubcategoryName,
				ModifiedDate = GETDATE()
		FROM inserted AS ins
		WHERE ins.SubcategoryID = Production.ProductSubcategory.ProductSubcategoryID
END;

GO

CREATE TRIGGER Production.Trg_vCategorySubCategory_Delete ON Production.vCategorySubCategory
INSTEAD OF DELETE AS
BEGIN
		DELETE FROM Production.ProductSubcategory 
		WHERE ProductSubcategoryID IN (SELECT SubcategoryID FROM deleted)

		DELETE FROM Production.ProductCategory 
		WHERE ProductCategoryID IN (SELECT CategoryID FROM deleted)
		AND ProductCategoryID NOT IN (SELECT ProductCategoryID FROM Production.ProductSubcategory)
END;

GO

/*
Вставьте новую строку в представление, указав новые данные для ProductCategory и ProductSubcategory. 
Триггер должен добавить новые строки в таблицы Production.ProductCategory и Production.ProductSubcategory.
Обновите вставленные строки через представление. Удалите строки.
*/

INSERT INTO Production.vCategorySubCategory (
	CategoryName,
	SubcategoryName,
	CategoryRowguid
)
VALUES ('Electronic devices', 'Apple', NEWID());

UPDATE Production.vCategorySubCategory SET
	CategoryName = 'Electronic devices 2',
	SubcategoryName = 'Apple 2'
WHERE CategoryName = 'Electronic devices';

DELETE FROM Production.vCategorySubCategory
WHERE CategoryName = 'Electronic devices 2';
