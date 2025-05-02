-- 1. How many products can you find in the Production.Product table?
-- Ans: 504
SELECT COUNT(ProductID) AS TotalNoOfProducts
FROM Production.Product

-- 2. A query that retrieves the number of products in the Production.Product table that are included in a subcategory. 
-- The rows that have NULL in column ProductSubcategoryID are considered to not be a part of any subcategory.
SELECT COUNT(ProductID) AS TotalNoOfProducts
FROM Production.Product 
WHERE ProductSubcategoryID IS NOT NULL;

SELECT * FROM Production.Product
WHERE ProductSubcategoryID IS NOT NULL;

-- 3. How many Products reside in each SubCategory? Write a query to display the results with the following titles.
SELECT p.ProductSubcategoryID, COUNT(ProductID) AS CountedProducts
FROM Production.Product p
JOIN Production.ProductSubcategory s
ON p.ProductSubcategoryID = s.ProductSubcategoryID
WHERE p.ProductSubcategoryID IS NOT NULL
GROUP BY p.ProductSubcategoryID

-- 4. How many products that do not have a product subcategory.
SELECT COUNT(ProductID) AS TotalNoOfProducts
FROM Production.Product 
WHERE ProductSubcategoryID IS NULL;

-- 5. query to list the sum of products quantity in the Production.ProductInventory table.
SELECT * FROM Production.ProductInventory


SELECT ProductID, SUM(Quantity) AS TheSum
FROM Production.ProductInventory
GROUP BY ProductID

-- 6. a query to list the sum of products in the Production.ProductInventory table and 
-- LocationID set to 40 and limit the result to include just summarized quantities less than 100.
SELECT ProductID, SUM(Quantity) AS TheSum
FROM Production.ProductInventory
WHERE LocationID = 40
GROUP BY ProductID
HAVING SUM(Quantity) < 100

-- 7. Write a query to list the sum of products with the shelf information in the Production.ProductInventory table and 
-- LocationID set to 40 and limit the result to include just summarized quantities less than 100
SELECT Shelf, ProductID, SUM(Quantity) AS TheSum
FROM Production.ProductInventory
WHERE LocationID = 40
GROUP BY Shelf, ProductID
HAVING SUM(Quantity) < 100

-- 8. query to list the average quantity for products 
-- where column LocationID has the value of 10 from the table Production.ProductInventory table.
SELECT ProductID, AVG(Quantity) AS TheAvg
FROM Production.ProductInventory
WHERE LocationID = 10
GROUP BY ProductID

-- 9. query  to see the average quantity  of  products by shelf  from the table Production.ProductInventory
SELECT ProductID, Shelf, AVG(Quantity) AS TheAvg
FROM Production.ProductInventory
GROUP BY ProductID, Shelf

-- 10. query  to see the average quantity  of  products by shelf excluding rows 
-- that has the value of N/A in the column Shelf from the table Production.ProductInventory
SELECT ProductID, Shelf, AVG(Quantity) AS TheAvg
FROM Production.ProductInventory
WHERE Shelf NOT IN ('N/A')
GROUP BY ProductID, Shelf

-- 11. List the members (rows) and average list price in the Production.Product table. 
-- This should be grouped independently over the Color and the Class column. 
-- Exclude the rows where Color or Class are null.
SELECT * FROM Production.Product

SELECT Color, Class, COUNT(ListPrice) AS TheCount, AVG(ListPrice) AS AvgPrice
FROM Production.Product
WHERE Color IS NOT NULL AND Class IS NOT NULL
GROUP BY Color, Class

-- JOIN
-- 12. a query that lists the country and province names from person. CountryRegion and person. 
-- StateProvince tables. Join them and produce a result set

SELECT cr.Name AS Country, sp.Name AS Province 
FROM Person.CountryRegion cr 
JOIN Person.StateProvince sp 
ON cr.CountryRegionCode = sp.CountryRegionCode

-- 13. a query that lists the country and province names from person. CountryRegion and person. 
-- StateProvince tables and list the countries filter them by Germany and Canada. 
-- Join them and produce a result set
SELECT cr.Name AS Country, sp.Name AS Province 
FROM Person.CountryRegion cr 
JOIN Person.StateProvince sp 
ON cr.CountryRegionCode = sp.CountryRegionCode
WHERE cr.Name IN ('Germany', 'Canada')

-- NorthWind
USE Northwind
GO

-- 14. List all Products that has been sold at least once in last 27 years.
SELECT * FROM dbo.[Orders]  

SELECT Distinct p.ProductName
FROM Products p 
JOIN [Order Details] od 
ON p.ProductID = od.ProductID 
JOIN Orders o
ON od.OrderID = o.OrderID
WHERE o.OrderDate >= DATEADD(YEAR, -27, GETDATE())

-- 15. List top 5 locations (Zip Code) where the products sold most.
SELECT DISTINCT TOP 5 o.ShipPostalCode, SUM(od.Quantity) AS TotalQuantity
FROM Products p 
JOIN [Order Details] od 
ON p.ProductID = od.ProductID 
JOIN Orders o
ON od.OrderID = o.OrderID
GROUP BY o.ShipPostalCode
ORDER BY TotalQuantity DESC

-- 16. List top 5 locations (Zip Code) where the products sold most in last 27 years.
SELECT DISTINCT TOP 5 o.ShipPostalCode, SUM(od.Quantity) AS TotalQuantity
FROM Products p 
JOIN [Order Details] od 
ON p.ProductID = od.ProductID 
JOIN Orders o
ON od.OrderID = o.OrderID
WHERE o.OrderDate >= DATEADD(YEAR, -27, GETDATE())
GROUP BY o.ShipPostalCode
ORDER BY TotalQuantity DESC

-- 17. List all city names and number of customers in that city. 
SELECT * FROM Customers

SELECT c.City, COUNT(c.CustomerID) AS NoOfCustomers
FROM Customers c 
GROUP BY c.City

-- 18. List city names which have more than 2 customers, and number of customers in that city
SELECT c.City, COUNT(c.CustomerID) AS NoOfCustomers
FROM Customers c 
GROUP BY c.City
HAVING COUNT(c.CustomerID) > 2

--19. List the names of customers who placed orders after 1/1/98 with order date.
SELECT DISTINCT c.ContactName, o.OrderDate
FROM Customers c JOIN [Orders] o ON c.CustomerID = o.CustomerID 
WHERE o.OrderDate > '1998-01-01';

-- 20. List the names of all customers with most recent order dates
SELECT c.ContactName, MAX(o.OrderDate) AS MostRecentOrder
FROM Customers c JOIN [Orders] o ON c.CustomerID = o.CustomerID 
GROUP By c.ContactName
ORDER BY MostRecentOrder DESC

-- 21. Display the names of all customers  along with the  count of products they bought
SELECT c.ContactName, SUM(od.Quantity) AS ProductsBought
FROM Customers c 
JOIN Orders o 
ON c.CustomerID = o.CustomerID 
JOIN [Order Details] od 
ON o.OrderID = od.OrderID
GROUP BY c.ContactName
ORDER BY ProductsBought DESC

-- 22. Display the customer ids who bought more than 100 Products with count of products.
SELECT c.CustomerID, SUM(od.Quantity) AS ProductsBought
FROM Customers c 
JOIN Orders o 
ON c.CustomerID = o.CustomerID 
JOIN [Order Details] od 
ON o.OrderID = od.OrderID
GROUP BY c.CustomerID
HAVING SUM(od.Quantity) > 100

-- 23. List all of the possible ways that suppliers can ship their products.
SELECT 
    s.CompanyName AS [Supplier Company Name],
    Shippers.CompanyName AS [Shipping Company Name]
FROM 
    Suppliers s
INNER JOIN 
    Products p ON s.SupplierID = p.SupplierID
INNER JOIN 
    [Order Details] od ON p.ProductID = od.ProductID
INNER JOIN 
    Orders o ON od.OrderID = o.OrderID
INNER JOIN 
    Shippers ON o.ShipVia = Shippers.ShipperID
GROUP BY 
    s.CompanyName, Shippers.CompanyName;

-- 24. Display the products order each day. Show Order date and Product Name.
SELECT 
    o.OrderDate,
    p.ProductName
FROM 
    Orders o
INNER JOIN 
    [Order Details] od ON o.OrderID = od.OrderID
INNER JOIN 
    Products p ON od.ProductID = p.ProductID
ORDER BY 
    o.OrderDate, p.ProductName;

-- 25.  Displays pairs of employees who have the same job title.
SELECT 
    E1.FirstName + ' ' + E1.LastName AS Employee1,
    E2.FirstName + ' ' + E2.LastName AS Employee2,
    E1.Title AS JobTitle
FROM 
    Employees E1
INNER JOIN 
    Employees E2 ON E1.Title = E2.Title AND E1.EmployeeID < E2.EmployeeID
ORDER BY 
    E1.Title, Employee1, Employee2;

-- 26. Display all the Managers who have more than 2 employees reporting to them.
SELECT 
    e1.EmployeeID AS ManagerID,
    e1.LastName AS ManagerLastName,
    e1.FirstName AS ManagerFirstName,
    COUNT(e2.EmployeeID) AS NumberOfReports
FROM 
    Employees e1
JOIN 
    Employees e2
ON 
    e1.EmployeeID = e2.ReportsTo
GROUP BY 
    e1.EmployeeID, e1.LastName, e1.FirstName
HAVING 
    COUNT(e2.EmployeeID) > 2;

-- 27. Display the customers and suppliers by city. The results should have the following columns
SELECT 
    City, 
    CompanyName, 
    ContactName, 
    'Customers' AS Relationship 
FROM 
    Customers
UNION
SELECT 
    City, 
    CompanyName, 
    ContactName, 
    'Suppliers' AS Relationship
FROM 
    Suppliers;