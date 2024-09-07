SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[SP_Ventas] 
	
AS
BEGIN TRY

	SET NOCOUNT ON;

	/*SE UNE LA FACT TABLE CON LAS DIMENSIONES DE PRODUCTO, CLIENTE, MONEDA Y ZONA GEOGRAFICA*/
SELECT
A.OrderDate,
A.ProductKey,
B.SpanishProductName,
C.Title,
C.FirstName,
C.LastName,
E.SpanishCountryRegionName,
F.SalesTerritoryRegion,
F.SalesTerritoryCountry,
E.City,
D.CurrencyName,
SUM(SalesAmount) AS SalesAmount
FROM AdventureWorksDW2012.dbo.FactInternetSales A
INNER JOIN AdventureWorksDW2012.dbo.DimProduct B ON A.ProductKey = B.ProductKey
INNER JOIN AdventureWorksDW2012.dbo.DimCustomer C ON A.CustomerKey = C.CustomerKey
INNER JOIN AdventureWorksDW2012.dbo.DimCurrency D ON A.CurrencyKey = D.CurrencyKey
INNER JOIN AdventureWorksDW2012.dbo.DimGeography E ON C.GeographyKey = E.GeographyKey
INNER JOIN AdventureWorksDW2012.dbo.DimSalesTerritory F ON A.SalesTerritoryKey = F.SalesTerritoryKey
GROUP BY
A.OrderDate,
A.ProductKey,
B.SpanishProductName,
C.Title,
C.FirstName,
C.LastName,
E.SpanishCountryRegionName,
F.SalesTerritoryRegion,
F.SalesTerritoryCountry,
E.City,
D.CurrencyName
END TRY
BEGIN CATCH
	/*EN CASO DE ERROR SE INSERTA EN LA TABLA DE LOG LOS ERRORES*/
	Insert into AdventureWorksDW2012.dbo.ErrorsLog(fecha, cod_error, error_date, error_linea, error_mensaje)
	values (getdate(),cast(error_number() as varchar(30)),getdate(),cast(error_line() as varchar(50)),cast(error_message() as varchar(3000)))

END CATCH
GO
