-- A Query that retrieves the columns ProductID, Name, Color and ListPrice from the Production.Product table.

-- 1. with no filter.
SELECT ProductID, Name, Color, ListPrice
FROM Production.Product

-- 2. excludes the rows that ListPrice is 0.
SELECT ProductID, Name, Color, ListPrice
FROM Production.Product
WHERE ListPrice > 0

-- 3. the rows that are NULL for the Color column.
SELECT ProductID, Name, Color, ListPrice
FROM Production.Product
WHERE Color IS NULL

-- 4. rows that are not NULL for the Color column.
SELECT ProductID, Name, Color, ListPrice
FROM Production.Product
WHERE Color IS NOT NULL

-- 5. rows that are not NULL for the column Color, and the column ListPrice has a value greater than zero.
SELECT ProductID, Name, Color, ListPrice
FROM Production.Product
WHERE Color IS NOT NULL AND ListPrice > 0

-- 6. query that concatenates the columns Name and Color from the Production.Product
-- table by excluding the rows that are null for color.
SELECT Name + ' ' + Color AS NameColor
FROM Production.Product
WHERE Color IS NOT NULL

-- 7
SELECT Name, Color
FROM Production.Product
WHERE Color IS NOT NULL
AND ProductID BETWEEN 317 AND 322

-- 8. query to retrieve the to the columns ProductID and Name from the Production.Product table filtered by ProductID from 400 to 500
SELECT ProductID, Name
FROM Production.Product
WHERE ProductID >= 400 AND ProductID <= 500

-- 9. query to retrieve the to the columns  ProductID, Name and color from the Production.Product table restricted to the colors black and blue
SELECT ProductID, Name, Color
FROM Production.Product
WHERE Color = 'Black' OR Color = 'Blue'

SELECT ProductID, Name, Color
FROM Production.Product
WHERE Color IN ('Black', 'Blue')

-- 10. query to get a result set on products that begins with the letter S. 
SELECT ProductID, Name
FROM Production.Product
WHERE Name LIKE 'S%'

-- 11. 
SELECT Name, ListPrice
FROM Production.Product
WHERE Name LIKE 'Se%' OR 
Name LIKE 'Short-Sleeve Classic Jersey, [L-M]%'
ORDER BY Name

-- 12.
SELECT Name, ListPrice
FROM Production.Product
WHERE Name LIKE 'A%' OR Name LIKE 'Seat [L-P]%'
ORDER BY Name

-- 13. query so you retrieve rows that have a Name that begins with the letters SPO, but is then not followed by the letter K. 
-- After this zero or more letters can exists. Order the result set by the Name column.
SELECT Name
FROM Production.Product
WHERE Name Like 'SPO[^K]%'
ORDER BY Name 

-- 14. query that retrieves unique colors from the table Production.Product. Order the results  in descending  manner.
SELECT DISTINCT Color
FROM Production.Product
ORDER BY Color DESC
