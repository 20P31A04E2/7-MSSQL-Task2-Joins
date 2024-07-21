use Sravanthi_sqlTask2;

select * from Employee;
select * from Orders;
select * from OrderDetails;
select * from Products;
select * from Shippers;
select * from Suppliers;

--1
select FirstName, LastName FROM Employee
INNER JOIN Orders ON Employee.EmployeeID = Orders.EmployeeID
WHERE OrderDate BETWEEN '1996-08-15' AND '1997-08-15';

--2
select distinct Employee.EmployeeID FROM Employee
INNER JOIN Orders ON Employee.EmployeeID = Orders.EmployeeID
WHERE OrderDate < '1996-10-16';

--3
select count(OrderDetails.ProductID) as TotalOrders from OrderDetails
INNER JOIN Orders ON OrderDetails.OrderID = Orders.OrderID
where OrderDate BETWEEN '1997-01-13' AND '1997-04-16';

--4
select count(Employee.EmployeeID) from Employee
INNER JOIN Orders ON Employee.EmployeeID = Orders.EmployeeID
where (OrderDate BETWEEN '1997-01-13' AND '1997-04-16')AND Employee.FirstName='Anne';

--5
select count(Employee.EmployeeID) from Employee
INNER JOIN Orders ON Employee.EmployeeID = Orders.EmployeeID
where Employee.FirstName='Robert';

--6
select count(Employee.EmployeeID) from Employee
INNER JOIN Orders ON Employee.EmployeeID = Orders.EmployeeID
where (OrderDate BETWEEN '1996-08-15' AND '1997-08-15')AND Employee.FirstName='Robert';

--7
select Employee.EmployeeID, CONCAT(FirstName,' ',LastName) AS FullName, HomePhone from Employee
INNER JOIN Orders ON Employee.EmployeeID = Orders.EmployeeID
WHERE OrderDate BETWEEN '1997-01-13' AND '1997-04-16';

--8
select TOP 1 Products.ProductID, Products.ProductName, COUNT(*) AS NumberOfOrders from Products
INNER JOIN OrderDetails ON Products.ProductID = OrderDetails.ProductID
GROUP BY Products.ProductID, Products.ProductName ORDER BY COUNT(*) DESC;

--9
select TOP 5 Products.ProductID, Products.ProductName, COUNT(*) AS NumberOfOrders from Products
INNER JOIN OrderDetails ON Products.ProductID = OrderDetails.ProductID
GROUP BY Products.ProductID, Products.ProductName ORDER BY COUNT(*);

--10
select UnitPrice AS Price from OrderDetails INNER JOIN Orders ON OrderDetails.OrderID = Orders.OrderID
INNER JOIN Employee ON Employee.EmployeeID = Orders.EmployeeID
where OrderDate='1997-01-13' AND Employee.FirstName='Laura';

--11
select COUNT(DISTINCT Orders.EmployeeID) AS UniqueEmployees from Orders
INNER JOIN OrderDetails ON Orders.OrderID = OrderDetails.OrderID
INNER JOIN Products ON OrderDetails.ProductID = Products.ProductID
WHERE Products.ProductName IN ('Gorgonzola Telino', 'Gnocchi di nonna Alice', 'Raclette Courdavault', 'Camembert Pierrot') AND Orders.OrderDate >= '1997-01-01' AND Orders.OrderDate < '1997-02-01';

--12
select CONCAT(FirstName,' ',LastName) AS FullName from Employee
INNER JOIN Orders on Employee.EmployeeId = Orders.EmployeeID
INNER JOIN OrderDetails ON Orders.OrderID = OrderDetails.OrderID
INNER JOIN Products ON OrderDetails.ProductID = Products.ProductID
where Products.ProductName='Tofu' AND (OrderDate BETWEEN '1997-01-13' AND '1997-01-30');

--13
select Employee.EmployeeID,
	    CONCAT(FirstName,' ',LastName),
		Year(GetDate())-Year(Employee.BirthDate) AS NoOfYears,
		(Year(GetDate())-Year(Employee.BirthDate))*12 AS NoOfMonths,
		(Year(GetDate())-Year(Employee.BirthDate))*365 AS NoOfDays from Employee
INNER JOIN Orders on Orders.EmployeeID=Employee.EmployeeID where Month(Orders.OrderDate)='08';
 
--14
select CompanyName, count(*) AS TotalOrders from Shippers
INNER JOIN Orders on Shippers.ShipperID = Orders.ShipperID
GROUP BY CompanyName ;

--15
select CompanyName, count(*) AS TotalProducts from Shippers
INNER JOIN Orders ON Shippers.ShipperID = Orders.ShipperID
INNER JOIN OrderDetails ON Orders.OrderID = OrderDetails.OrderID
GROUP BY CompanyName;

--16
select TOP 1 Shippers.ShipperID,CompanyName, count(*) AS TotalOrders from Shippers
INNER JOIN Orders on Shippers.ShipperID = Orders.ShipperID
GROUP BY Shippers.ShipperID,CompanyName ORDER BY COUNT(*) DESC;

--17
select TOP 1 CompanyName, count(*) AS TotalProducts from Shippers
INNER JOIN Orders ON Shippers.ShipperID = Orders.ShipperID
INNER JOIN OrderDetails ON Orders.OrderID = OrderDetails.OrderID
where ShippedDate BETWEEN '1996-08-10' AND '1998-09-20' GROUP BY CompanyName;

--18
SELECT Employee.EmployeeID, CONCAT(FirstName, ' ', LastName) AS FullName  FROM Employee 
LEFT JOIN Orders ON Employee.EmployeeID = Orders.EmployeeID AND Orders.OrderDate = '1997-04-04'
GROUP BY Employee.EmployeeID, FirstName, LastName
HAVING COUNT(Orders.OrderID) = 0;

--19
select COUNT(OrderDetails.ProductID) AS TotalProductsShipped FROM Employee
INNER JOIN Orders on Employee.EmployeeID = Orders.EmployeeID
INNER JOIN OrderDetails ON Orders.OrderId= OrderDetails.OrderID
INNER JOIN Products ON OrderDetails.ProductID = Products.ProductID
where Employee.FirstName = 'Steven'; 

--20
select COUNT(OrderDetails.ProductID) AS TotalProductsShipped FROM Employee
INNER JOIN Orders on Employee.EmployeeID = Orders.EmployeeID
INNER JOIN OrderDetails ON Orders.OrderId= OrderDetails.OrderID
INNER JOIN Products ON OrderDetails.ProductID = Products.ProductID
INNER JOIN Shippers ON Orders.ShipperID = Shippers.ShipperID
where Employee.FirstName = 'Michael' AND Shippers.CompanyName='Federal Shipping';

--21
SELECT COUNT(Orders.OrderID) AS TotalOrders FROM Orders
INNER JOIN OrderDetails ON Orders.OrderID = OrderDetails.OrderID
INNER JOIN Products ON OrderDetails.ProductID = Products.ProductID
INNER JOIN Suppliers ON Products.SupplierID = Suppliers.SupplierID
WHERE Suppliers.Country IN ('UK', 'Germany');

--22
select COUNT(Orders.OrderID) AS TotalOrders From Orders
INNER JOIN OrderDetails ON Orders.OrderID = OrderDetails.OrderID
INNER JOIN Products ON OrderDetails.ProductID = Products.ProductID
INNER JOIN Suppliers ON Products.SupplierID = Suppliers.SupplierID
where Suppliers.CompanyName = 'Exotic Liquids' AND OrderDate BETWEEN '1997-01-01' AND '1997-01-31';

--23 doubt
SELECT DISTINCT DAY(Orders.OrderDate) AS NoOrdersDate
FROM Orders  
LEFT JOIN OrderDetails ON OrderDetails.OrderID = Orders.OrderID 
LEFT JOIN Products ON Products.ProductID = OrderDetails.ProductID 
LEFT JOIN Suppliers ON Suppliers.SupplierID = Products.SupplierID 
WHERE Orders.OrderDate BETWEEN '1997-01-01' AND '1997-01-31' 
AND (Suppliers.CompanyName <> 'Tokyo Traders' OR Suppliers.CompanyName IS NULL);


--24
SELECT Employee.EmployeeID, Employee.FirstName, Employee.LastName FROM Employee
WHERE Employee.EmployeeID NOT IN (
    SELECT Orders.EmployeeID FROM Orders
    INNER JOIN OrderDetails ON Orders.OrderID = OrderDetails.OrderID
    INNER JOIN Products ON OrderDetails.ProductID = Products.ProductID
    INNER JOIN Suppliers ON Products.SupplierID = Suppliers.SupplierID
    WHERE Suppliers.CompanyName = 'Ma Maison' AND MONTH(Orders.OrderDate) = 5)
ORDER BY Employee.EmployeeID;

--25
SELECT TOP 1 Shippers.CompanyName, COUNT(OrderDetails.ProductID) AS TotalProductsShipped FROM Orders
INNER JOIN Shippers ON Orders.ShipperID = Shippers.ShipperID
INNER JOIN OrderDetails ON Orders.OrderID = OrderDetails.OrderID
INNER JOIN Products ON Products.ProductID = OrderDetails.ProductID
WHERE (MONTH(Orders.ShippedDate) = '09' OR MONTH(Orders.ShippedDate) = '10') AND YEAR(Orders.ShippedDate) = '1997'
GROUP BY Shippers.CompanyName
ORDER BY TotalProductsShipped;

--26
SELECT Products.ProductName FROM Products
JOIN OrderDetails ON Products.ProductID = OrderDetails.ProductID
JOIN Orders ON OrderDetails.OrderID = Orders.OrderID
AND Orders.OrderDate BETWEEN '1997-08-01' AND '1997-08-31' 
GROUP BY Products.ProductName HAVING COUNT(Orders.OrderID)=0;

--27
SELECT Employee.FirstName AS EmployeeName, Products.ProductName FROM Employee
CROSS JOIN Products
LEFT JOIN OrderDetails ON Products.ProductID = OrderDetails.ProductID
LEFT JOIN Orders ON OrderDetails.OrderID = Orders.OrderID AND Orders.EmployeeID = Employee.EmployeeID
WHERE Orders.OrderID IS NULL
GROUP BY Employee.FirstName,Products.ProductName
ORDER BY EmployeeName, ProductName;

--28
SELECT TOP 1 Shippers.CompanyName, COUNT(*) AS TotalProductsShipped FROM Shippers
INNER JOIN Orders ON Orders.ShipperID = Shippers.ShipperID
WHERE (YEAR(Orders.ShippedDate) = 1996 AND MONTH(Orders.ShippedDate) IN (4, 5, 6)) OR (YEAR(Orders.ShippedDate) = 1997 AND MONTH(Orders.ShippedDate) IN (4, 5, 6))
GROUP BY Shippers.CompanyName
ORDER BY TotalProductsShipped DESC;

--29
SELECT TOP 1 Suppliers.Country, COUNT(OrderDetails.ProductID) AS TotalProductsSupplied FROM OrderDetails
INNER JOIN Products ON OrderDetails.ProductID = Products.ProductID
INNER JOIN Suppliers ON Products.SupplierID = Suppliers.SupplierID
INNER JOIN Orders ON OrderDetails.OrderID = Orders.OrderID
WHERE YEAR(Orders.ShippedDate) = 1997
GROUP BY Suppliers.Country
ORDER BY TotalProductsSupplied DESC;

--30
SELECT AVG(DATEDIFF(day, Orders.OrderDate, Orders.ShippedDate)) AS AverageShippingDays FROM Orders
WHERE Orders.ShippedDate IS NOT NULL;

--31
SELECT TOP 1 Shippers.CompanyName, MIN(DATEDIFF(day, Orders.OrderDate, Orders.ShippedDate)) AS MinShippingDays FROM Orders
INNER JOIN Shippers ON Orders.ShipperID = Shippers.ShipperID
WHERE Orders.ShippedDate IS NOT NULL
GROUP BY Shippers.CompanyName
ORDER BY MinShippingDays;

--32
SELECT TOP 1 Orders.OrderID,
    CONCAT(Employee.FirstName, ' ', Employee.LastName) AS FullName,
	Count(OrderDetails.ProductID) AS NoOfProducts,
    DATEDIFF(day, Orders.OrderDate, Orders.ShippedDate) AS ShippingDays,
    Shippers.CompanyName AS ShipperCompanyName FROM Orders
INNER JOIN Employee ON Orders.EmployeeID = Employee.EmployeeID
INNER JOIN OrderDetails ON Orders.OrderID = OrderDetails.OrderID
INNER JOIN Shippers ON Orders.ShipperID = Shippers.ShipperID
WHERE Orders.ShippedDate IS NOT NULL
GROUP BY Orders.OrderID, Employee.FirstName, Employee.LastName, Orders.OrderDate, Orders.ShippedDate, Shippers.CompanyName
ORDER BY ShippingDays ASC;


--UNIONS
--33
SELECT '1' AS Label,
       Orders.OrderID,
       DATEDIFF(day, Orders.OrderDate, Orders.ShippedDate) AS NoOfDays,
       Shippers.CompanyName,
       CONCAT(Employee.FirstName, ' ', Employee.LastName) AS FullName,
       COUNT(Products.ProductName) AS NoOfProducts
FROM Orders
JOIN OrderDetails ON Orders.OrderID = OrderDetails.OrderID
JOIN Products ON Products.ProductID = OrderDetails.ProductID
JOIN Shippers ON Shippers.ShipperID = Orders.ShipperID
JOIN Employee ON Employee.EmployeeID = Orders.EmployeeID
WHERE Orders.ShippedDate IS NOT NULL
GROUP BY Orders.OrderID, Orders.OrderDate, Orders.ShippedDate, Shippers.CompanyName, Employee.FirstName, Employee.LastName
HAVING DATEDIFF(day, Orders.OrderDate, Orders.ShippedDate) = (SELECT MIN(DATEDIFF(day, OrderDate, ShippedDate))FROM Orders
WHERE ShippedDate IS NOT NULL)
UNION
SELECT '2' AS Label,
       Orders.OrderID,
       DATEDIFF(day, Orders.OrderDate, Orders.ShippedDate) AS NoOfDays,
       Shippers.CompanyName,
       CONCAT(Employee.FirstName, ' ', Employee.LastName) AS FullName,
       COUNT(Products.ProductName) AS NoOfProducts
FROM Orders
JOIN OrderDetails ON Orders.OrderID = OrderDetails.OrderID
JOIN Products ON Products.ProductID = OrderDetails.ProductID
JOIN Shippers ON Shippers.ShipperID = Orders.ShipperID
JOIN Employee ON Employee.EmployeeID = Orders.EmployeeID
WHERE Orders.ShippedDate IS NOT NULL
GROUP BY Orders.OrderID, Orders.OrderDate, Orders.ShippedDate, Shippers.CompanyName, Employee.FirstName, Employee.LastName
HAVING DATEDIFF(day, Orders.OrderDate, Orders.ShippedDate) = (SELECT MAX(DATEDIFF(day, OrderDate, ShippedDate))FROM Orders
WHERE ShippedDate IS NOT NULL)
ORDER BY NoOfDays ASC;

--34
Select ProductID, ProductName, UnitPrice, 1 AS ProductLabel 
from (Select Top 1 Products.ProductID, Products.ProductName, Products.UnitPrice from Products 
Inner Join OrderDetails On OrderDetails.ProductID = Products.ProductID
Inner Join Orders On OrderDetails.OrderID = Orders.OrderID 
Where YEAR(OrderDate) = '1997' and MONTH(OrderDate) = '10' and OrderDate Between '1997-10-07' and '1997-10-14' 
ORDER BY Products.UnitPrice ASC) AS CheapestProduct
UNION
Select ProductID, ProductName, UnitPrice, 2 AS ProductLabel
from (Select Top 1 Products.ProductID, Products.ProductName, Products.UnitPrice from Products 
Inner Join OrderDetails On OrderDetails.ProductID= Products.ProductID 
Inner Join Orders On OrderDetails.OrderID = Orders.OrderID 
Where YEAR(OrderDate) = '1997' and MONTH(OrderDate) = '10' and OrderDate Between '1997-10-07' and '1997-10-14'  
ORDER BY Products.UnitPrice DESC) AS CostliestProduct
ORDER BY ProductLabel;

--CASE
--35
select DISTINCT Employee.EmployeeID,Orders.ShipperID,
CASE 
        WHEN Orders.ShipperID = 1 THEN 'Shipping Federal'
        WHEN Orders.ShipperID = 2 THEN 'Express Speedy'
        WHEN Orders.ShipperID = 3 THEN 'United Package'
		ELSE Orders.ShipName
    END AS ShipperName
FROM Orders
INNER JOIN Employee ON Orders.EmployeeID = Employee.EmployeeID
WHERE Orders.EmployeeID IN (1, 3, 5, 7);
