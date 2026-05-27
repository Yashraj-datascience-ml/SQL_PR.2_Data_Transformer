-- Create Database
CREATE DATABASE IF NOT EXISTS DataTransformer;
USE DataTransformer;

-- =============================
-- 1. CUSTOMERS TABLE
-- =============================
CREATE TABLE IF NOT EXISTS Customers (
    CustomerID INT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Email VARCHAR(100),
    RegistrationDate DATE
);

INSERT INTO Customers VALUES
(1, 'John', 'Doe', 'john.doe@email.com', '2022-03-15'),
(2, 'Jane', 'Smith', 'jane.smith@email.com', '2021-11-02');

-- =============================
-- 2. ORDERS TABLE
-- =============================
CREATE TABLE IF NOT EXISTS Orders (
    OrderID INT PRIMARY KEY,
    CustomerID INT,
    OrderDate DATE,
    TotalAmount DECIMAL(10,2),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

INSERT INTO Orders VALUES
(101, 1, '2023-07-01', 150.50),
(102, 2, '2023-07-03', 200.75);

-- =============================
-- 3. EMPLOYEES TABLE
-- =============================
CREATE TABLE IF NOT EXISTS Employees (
    EmployeeID INT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Department VARCHAR(50),
    HireDate DATE,
    Salary DECIMAL(10,2)
);

INSERT INTO Employees VALUES
(1, 'Mark', 'Johnson', 'Sales', '2020-01-15', 50000),
(2, 'Susan', 'Lee', 'HR', '2021-03-20', 55000);

-- =============================
-- QUERIES
-- =============================

-- 1. INNER JOIN
SELECT c.*, o.*
FROM Customers c
INNER JOIN Orders o ON c.CustomerID = o.CustomerID;

-- 2. LEFT JOIN
SELECT c.*, o.*
FROM Customers c
LEFT JOIN Orders o ON c.CustomerID = o.CustomerID;

-- 3. RIGHT JOIN
SELECT c.*, o.*
FROM Customers c
RIGHT JOIN Orders o ON c.CustomerID = o.CustomerID;

-- 4. FULL OUTER JOIN (MySQL workaround)
SELECT c.*, o.*
FROM Customers c
LEFT JOIN Orders o ON c.CustomerID = o.CustomerID
UNION
SELECT c.*, o.*
FROM Customers c
RIGHT JOIN Orders o ON c.CustomerID = o.CustomerID;

-- 5. Subquery (customers with orders > avg)
SELECT * FROM Customers
WHERE CustomerID IN (
    SELECT CustomerID FROM Orders
    WHERE TotalAmount > (SELECT AVG(TotalAmount) FROM Orders)
);

-- 6. Subquery (employees > avg salary)
SELECT * FROM Employees
WHERE Salary > (SELECT AVG(Salary) FROM Employees);

-- 7. Extract year & month
SELECT OrderID,
       YEAR(OrderDate) AS Year,
       MONTH(OrderDate) AS Month
FROM Orders;

-- 8. Date difference
SELECT OrderID,
       DATEDIFF(CURDATE(), OrderDate) AS DaysDifference
FROM Orders;

-- 9. Format date
SELECT OrderID,
       DATE_FORMAT(OrderDate, '%d-%m-%Y') AS FormattedDate
FROM Orders;

-- 10. Concatenate names
SELECT CONCAT(FirstName, ' ', LastName) AS FullName
FROM Customers;

-- 11. Replace string
SELECT REPLACE(FirstName, 'John', 'Jonathan') AS UpdatedName
FROM Customers;

-- 12. Upper & lower
SELECT UPPER(FirstName), LOWER(LastName)
FROM Customers;

-- 13. Trim spaces
SELECT TRIM(Email) FROM Customers;

-- 14. Running total
SELECT OrderID, TotalAmount,
       SUM(TotalAmount) OVER (ORDER BY OrderID) AS RunningTotal
FROM Orders;

-- 15. Rank orders
SELECT OrderID, TotalAmount,
       RANK() OVER (ORDER BY TotalAmount DESC) AS RankValue
FROM Orders;

-- 16. Discount using CASE
SELECT OrderID, TotalAmount,
CASE
    WHEN TotalAmount > 1000 THEN '10% Discount'
    WHEN TotalAmount > 500 THEN '5% Discount'
    ELSE 'No Discount'
END AS Discount
FROM Orders;

-- 17. Salary category
SELECT EmployeeID, Salary,
CASE
    WHEN Salary > 60000 THEN 'High'
    WHEN Salary BETWEEN 50000 AND 60000 THEN 'Medium'
    ELSE 'Low'
END AS SalaryCategory
FROM Employees;