-- 1. List all cities that have both Employees and Customers.
SELECT DISTINCT City
FROM Employees
WHERE City IS NOT NULL
INTERSECT
SELECT DISTINCT City
FROM Customers
WHERE City IS NOT NULL;

-- 2. List all cities that have Customers but no Employee.
-- a. Use sub-query
SELECT DISTINCT City
FROM Customers
WHERE City IS NOT NULL
  AND City NOT IN (
      SELECT DISTINCT City
      FROM Employees
      WHERE City IS NOT NULL
  );

-- b. do not use sub-query
SELECT DISTINCT City
FROM Customers
WHERE City IS NOT NULL
EXCEPT
SELECT DISTINCT City
FROM Employees
WHERE City IS NOT NULL;

-- 3. List all products and their total order quantities throughout all orders.
SELECT DISTINCT p.ProductName, SUM(od.Quantity) AS TotalOrderQuantity
FROM Products p
LEFT JOIN [Order Details] od ON p.ProductID = od.ProductID
GROUP BY p.ProductName
ORDER BY TotalOrderQuantity DESC

-- 4. List all Customer Cities and total products ordered by that city.
SELECT DISTINCT c.City, SUM(od.Quantity) AS TotalProductsOrdered
FROM Customers c
JOIN [Orders] o ON c.CustomerID = o.CustomerID
JOIN [Order Details] od ON od.OrderID = o.OrderID
GROUP By c.City
ORDER BY TotalProductsOrdered DESC

-- 5.  List all Customer Cities that have at least two customers.
SELECT c.City, COUNT(DISTINCT c.CustomerID) AS CustomerCount
FROM Customers c 
JOIN Orders o 
ON c.CustomerID = o.CustomerID
GROUP BY c.City
HAVING COUNT(DISTINCT c.CustomerID) >= 2
ORDER BY CustomerCount DESC

-- 6. List all Customer Cities that have ordered at least two different kinds of products.
SELECT c.City, COUNT(DISTINCT od.ProductID) AS DistinctProductsOrdered 
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
JOIN [Order Details] od ON od.OrderID = o.OrderID
GROUP BY c.City
HAVING COUNT(DISTINCT od.ProductID) >= 2
ORDER BY DistinctProductsOrdered DESC

-- 7. List all Customers who have ordered products, but have the ‘ship city’ on the order different from their own customer cities.
SELECT DISTINCT c.ContactName
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
JOIN [Order Details] od ON o.OrderID = od.OrderID
WHERE c.City IS NOT NULL
    AND o.ShipCity IS NOT NULL
    AND c.City <> o.ShipCity

-- 8. List 5 most popular products, their average price, and the customer city that ordered most quantity of it.
WITH ProductTotals AS (
    SELECT 
        od.ProductID,
        SUM(od.Quantity) AS TotalQuantity,
        AVG(od.UnitPrice) AS AvgPrice
    FROM 
        [Order Details] od
    GROUP BY 
        od.ProductID
),
TopProducts AS (
    SELECT TOP 5
        pt.ProductID,
        pt.TotalQuantity,
        pt.AvgPrice
    FROM 
        ProductTotals pt
    ORDER BY 
        pt.TotalQuantity DESC 
),
CityOrders AS (
    SELECT 
        od.ProductID,
        o.ShipCity,
        SUM(od.Quantity) AS QtyByCity
    FROM 
        [Order Details] od
    JOIN 
        Orders o ON od.OrderID = o.OrderID
    GROUP BY 
        od.ProductID, o.ShipCity
),
TopProductCity AS (
    SELECT 
        co.ProductID,
        co.ShipCity AS TopCustomerCity,
        co.QtyByCity,
        RANK() OVER (PARTITION BY co.ProductID ORDER BY co.QtyByCity DESC) AS rnk
    FROM 
        CityOrders co
)
SELECT 
    tp.ProductID,
    p.ProductName,
    tp.AvgPrice,
    tpc.TopCustomerCity,
    tp.TotalQuantity
FROM 
    TopProducts tp
JOIN 
    Products p ON tp.ProductID = p.ProductID
JOIN 
    TopProductCity tpc ON tp.ProductID = tpc.ProductID AND tpc.rnk = 1
ORDER BY 
    tp.TotalQuantity DESC;


-- 9. List all cities that have never ordered something but we have employees there.
-- a. Use sub-query
SELECT DISTINCT e.City
FROM Employees e
WHERE e.City IS NOT NULL
  AND e.City NOT IN (
      SELECT DISTINCT o.ShipCity
      FROM Orders o
      WHERE o.ShipCity IS NOT NULL
  );

-- b. Do not use sub-query

SELECT DISTINCT e.City
FROM Employees e
LEFT JOIN Orders o ON e.City = o.ShipCity
WHERE o.ShipCity IS NULL AND e.City IS NOT NULL;

-- 10. List one city, if exists, that is the city from where the employee sold most orders (not the product quantity) is, 
-- and also the city of most total quantity of products ordered from. (tip: join  sub-query)
-- CTEs for clarity
WITH OrdersPerEmployeeCity AS (
    SELECT e.City AS EmpCity, COUNT(DISTINCT o.OrderID) AS TotalOrders
    FROM Employees e
    JOIN Orders o ON e.EmployeeID = o.EmployeeID
    WHERE e.City IS NOT NULL
    GROUP BY e.City
),
TopEmpCity AS (
    SELECT TOP 1 EmpCity
    FROM OrdersPerEmployeeCity
    ORDER BY TotalOrders DESC
),
QuantityPerShipCity AS (
    SELECT o.ShipCity, SUM(od.Quantity) AS TotalQuantity
    FROM Orders o
    JOIN [Order Details] od ON o.OrderID = od.OrderID
    WHERE o.ShipCity IS NOT NULL
    GROUP BY o.ShipCity
),
TopShipCity AS (
    SELECT TOP 1 ShipCity
    FROM QuantityPerShipCity
    ORDER BY TotalQuantity DESC
)

-- Final output
SELECT 
    t1.EmpCity AS EmployeeCityWithMostOrders,
    t2.ShipCity AS ShipCityWithMostQuantity
FROM 
    TopEmpCity t1
JOIN 
    TopShipCity t2 ON 1 = 1;


-- 11. How do you remove the duplicates record of a table?
-- Ans:- Identify duplicates using ROW_NUMBER() and delete all but one.






