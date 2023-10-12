--Cleansing Dim_date table
SELECT 
  [DateKey], 
  [FullDateAlternateKey] AS Day,
  --  ,[DayNumberOfWeek]
  [EnglishDayNameOfWeek] AS Date,
  --,[SpanishDayNameOfWeek]
  --,[FrenchDayNameOfWeek]
  --,[DayNumberOfMonth]
  --,[DayNumberOfYear]
  [WeekNumberOfYear] AS WeekNo, 
  [EnglishMonthName] AS Month,
  LEFT([EnglishMonthName], 3) AS MonthShort,
  --,[SpanishMonthName]
  --,[FrenchMonthName]
  [MonthNumberOfYear] AS MonthNo, 
  [CalendarQuarter] AS Quarter, 
  [CalendarYear] AS Year
  --,[CalendarSemester]
  --,[FiscalQuarter]
  --,[FiscalYear]
  --,[FiscalSemester]
FROM 
	[AdventureWorksDW2022].[dbo].[DimDate]
WHERE
	CalendarYear >= '2019'

-- cleansed dim_customers table
SELECT 
  c.customerkey AS CustomerKey, 
  --,[GeographyKey]
  --,[CustomerAlternateKey]
  --,[Title]
  c.firstname AS FirstName, 
  --,[MiddleName]
  c.lastname AS LastName, 
  --Combine first name and lastname
  c.firstname + ' ' + c.lastname AS FullName, 
  --,[NameStyle]
  --,[BirthDate]
  --,[MaritalStatus]
  --,[Suffix]
  CASE 
	c.gender 
WHEN 
	'M' THEN 'Male' 
WHEN 
	'F' THEN 'Female' 
END 
	AS Gender, 
  --[EmailAddress]
  --,[YearlyIncome]
  --,[TotalChildren]
  --,[NumberChildrenAtHome]
  --,[EnglishEducation]
  --,[SpanishEducation]
  --,[FrenchEducation]
  --,[EnglishOccupation]
  --,[SpanishOccupation]
  --,[FrenchOccupation]
  --,[HouseOwnerFlag]
  --,[NumberCarsOwned]
  --,[AddressLine1]
  --,[AddressLine2]
  --,[Phone]
  c.DateFirstPurchase AS DateFirstPurchase, 
  --,[CommuteDistance]
  g.city AS CustomerCity -- Joined customer city from geography table
FROM 
  [AdventureWorksDW2022].[dbo].[DimCustomer] AS c 
  LEFT JOIN [AdventureWorksDW2022].[dbo].[DimGeography] AS g ON g.geographykey = c.geographykey 
ORDER BY 
  customerkey

  --cleansed DIM Product table
SELECT 
  p.[ProductKey], 
  p.[ProductAlternateKey] AS ProductItemCode --,[ProductSubcategoryKey]
  --,[WeightUnitMeasureCode]
  --,[SizeUnitMeasureCode]
  , 
  p.[EnglishProductName] AS ProductName, 
  ps.EnglishProductSubcategoryName AS SubCategory --Joined from Subcategory Table
  , 
  pc.EnglishProductCategoryName AS ProductCategory --Joined from Category Table
  --,[SpanishProductName]
  --,[FrenchProductName]
  --,[StandardCost]
  --,[FinishedGoodsFlag]
  , 
  p.[Color] AS ProductColor --,[SafetyStockLevel]
  --,[ReorderPoint]
  --,[ListPrice]
  , 
  p.[Size] AS ProductSize --,[SizeRange]
  --,[Weight]
  --,[DaysToManufacture]
  , 
  p.[ProductLine] AS ProductLine --,[DealerPrice]
  --,[Class]
  --,[Style]
  , 
  p.[ModelName] AS ProductModelName --[LargePhoto]
  , 
  p.[EnglishDescription] AS ProductDescription, 
  --[FrenchDescription] 
  --,[ChineseDescription]
  --,[ArabicDescription]
  --,[HebrewDescription]
  --,[ThaiDescription]
  --,[GermanDescription]
  --,[JapaneseDescription]
  --,[TurkishDescription]
  --,[StartDate]
  --,[EndDate]
   
  ISNULL(p.[Status], 'Outdated') AS ProductStatus 
FROM 
  [AdventureWorksDW2022].[dbo].[DimProduct] AS p 
  LEFT JOIN dbo.DimProductSubcategory AS ps ON ps.ProductSubcategoryKey = p.ProductSubcategoryKey 
  LEFT JOIN dbo.DimProductCategory AS pc ON pc.ProductCategoryKey = ps.ProductCategoryKey 
ORDER BY 
  p.ProductKey

  -- Cleansed Fact InternetSales Table
SELECT 
  [ProductKey], 
  [OrderDateKey], 
  [DueDateKey], 
  [ShipDateKey], 
  [CustomerKey] --,[PromotionKey]
  --,[CurrencyKey]
  --,[SalesTerritoryKey]
  , 
  [SalesOrderNumber] --,[SalesOrderLineNumber]
  --,[RevisionNumber]
  --,[OrderQuantity]
  --,[UnitPrice]
  --,[ExtendedAmount]
  --,[UnitPriceDiscountPct]
  --,[DiscountAmount]
  --,[ProductStandardCost]
  --,[TotalProductCost]
  , 
  [SalesAmount] --,[TaxAmt]
  --,[Freight]
  --,[CarrierTrackingNumber]
  --,[CustomerPONumber]
  --,[OrderDate]
  --,[DueDate]
  --,[ShipDate]
FROM 
  [AdventureWorksDW2022].[dbo].[FactInternetSales] 
WHERE 
  LEFT (OrderDateKey, 4) >= YEAR(
    GETDATE()
  ) -2 -- ENSURES ONLY 2 YEARS OF DATE IS BROUGHT FROM EXTRACTION
ORDER BY 
  OrderDateKey
