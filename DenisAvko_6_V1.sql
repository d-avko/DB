USE AdventureWorks2012;
GO

/*  Создайте хранимую процедуру, которая будет возвращать сводную таблицу (оператор PIVOT), 
отображающую данные о суммарном количестве проданных продуктов (Sales.SalesOrderDetail.OrderQty) 
за определенный год (Sales.SalesOrderHeader.OrderDate). Список лет передайте в процедуру через входной параметр. */

CREATE PROCEDURE dbo.SalesForTheYear(@Years NVARCHAR(255)) AS
	DECLARE @Query AS NVARCHAR(1024);
	SET @Query = '
		SELECT ''Sales sum'' as Sum_By_year ,
		' + @Years + '
		FROM (  
			SELECT detail.OrderQty, YEAR(header.OrderDate) as OrderDate
			FROM Sales.SalesOrderDetail AS detail
				INNER JOIN Sales.SalesOrderHeader AS header
					ON detail.SalesOrderID = header.SalesOrderID
			) as p
		PIVOT
		(
			SUM(p.OrderQty)
			FOR p.OrderDate IN (' + @Years + ')
		) AS pvt'
    EXECUTE sp_executesql @Query;
GO

EXECUTE dbo.SalesForTheYear '[2005],[2006]';

/*SELECT 'Sales sum' as Sum_By_year ,
	[2005], [2006]
		FROM (  
			SELECT detail.OrderQty, YEAR(header.OrderDate) as OrderDate
			FROM Sales.SalesOrderDetail AS detail
				INNER JOIN Sales.SalesOrderHeader AS header
					ON detail.SalesOrderID = header.SalesOrderID
			) as p
		PIVOT
		(
			SUM(p.OrderQty)
			FOR p.OrderDate IN ([2005],[2006])
		) AS pvt*/