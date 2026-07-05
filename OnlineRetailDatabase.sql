-- CREATION OF DATABASE-------------------------------------------------------
CREATE DATABASE IF NOT EXISTS OnlineRetailDB;
USE OnlineRetailDB;

-- CREATION OF CUSTOMER TABLE
CREATE TABLE Customers(
CustomerID INT PRIMARY KEY AUTO_INCREMENT,
FirstName VARCHAR(50),
LastName VARCHAR(50),
Email VARCHAR(100),
Phone VARCHAR(50),
Address VARCHAR(255),
City VARCHAR(50),
State VARCHAR(50),
ZipCode VARCHAR(50),
Country VARCHAR(50),
CreatedAt DATETIME DEFAULT NOW()
);
ALTER TABLE Customers
ADD LastName VARCHAR(50)
AFTER FirstName;
-- CREATION OF PRODUCT TABLE
CREATE TABLE Products(
ProductID INT PRIMARY KEY AUTO_INCREMENT,
ProductName VARCHAR(100),
CategoryID INT,
Price DECIMAL(10,2),
Stock INT,
CreatedAt DATETIME DEFAULT NOW()
);
-- CREATION OF CATEGORY TABLE
CREATE TABLE Categories(
CategoryID INT PRIMARY KEY AUTO_INCREMENT,
CategoryName VARCHAR(100),
Description VARCHAR(255)
);
-- CREATION OF ORDER TABLE
CREATE TABLE Orders(
OrderID INT PRIMARY KEY AUTO_INCREMENT,
CustomerID INT,
OrderDate DATETIME DEFAULT NOW(),
TotalAmount DECIMAL(10,2),
CONSTRAINT orders_fk FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

-- CREATION OF Orderitems TABLE
CREATE TABLE OrderItems(
OrderItemID INT PRIMARY KEY AUTO_INCREMENT,
OrderID INT,
ProductID INT,
Quantity INT,
FOREIGN KEY(ProductID) REFERENCES Products(ProductID),
FOREIGN KEY(OrderID) REFERENCES Orders(OrderID)
);
ALTER TABLE OrderItems
ADD Price DECIMAL(10,2)
AFTER Quantity;

-- Insert sample data into Categories table
INSERT INTO Categories (CategoryName, Description) 
VALUES 
('Electronics', 'Devices and Gadgets'),
('Clothing', 'Apparel and Accessories'),
('Books', 'Printed and Electronic Books');

-- Insert sample data into Products table
INSERT INTO Products(ProductName, CategoryID, Price, Stock)
VALUES 
('Smartphone', 1, 699.99, 50),
('Laptop', 1, 999.99, 30),
('T-shirt', 2, 19.99, 100),
('Jeans', 2, 49.99, 60),
('Fiction Novel', 3, 14.99, 200),
('Science Journal', 3, 29.99, 150);

INSERT INTO Products(ProductName, CategoryID, Price, Stock)
VALUES 
('Keyboard', 1, 40.00, 0);
-- Insert sample data into Customers table
INSERT INTO Customers(FirstName, LastName, Email, Phone, Address, City, State, ZipCode, Country)
VALUES 
('Sameer', 'Khanna', 'sameer.khanna@example.com', '123-456-7890', '123 Elm St.', 'Springfield', 
'IL', '62701', 'USA'),
('Jane', 'Smith', 'jane.smith@example.com', '234-567-8901', '456 Oak St.', 'Madison', 
'WI', '53703', 'USA'),
('harshad', 'patel', 'harshad.patel@example.com', '345-678-9012', '789 Dalal St.', 'Mumbai', 
'Maharashtra', '41520', 'INDIA');

INSERT INTO Customers(FirstName, LastName, Email, Phone, Address, City, State, ZipCode, Country)
VALUES 
('Roshan', 'Kumar', 'roshan.kumar@example.com', '123-496-7690', '123 Elm St.', 'Springfield', 
'IL', '62701', 'USA'),
('Rahul', 'Sinha', 'rahul.sinha@example.com', '235-569-8931', '456 Oak St.', 'Madison', 
'WI', '53703', 'USA');

-- Insert sample data into Orders table
INSERT INTO Orders(CustomerId, OrderDate, TotalAmount)
VALUES 
(1, now(), 719.98),
(2, now(), 49.99),
(3, now(),44.98);

-- Insert sample data into OrderItems table
INSERT INTO OrderItems(OrderID, ProductID, Quantity, Price)
VALUES 
(1, 1, 1, 699.99),
(1, 3, 1, 19.99),
(2, 4, 1,  49.99),
(3, 5, 1, 14.99),
(3, 6, 1, 29.99);

-- --------------------------- QUERY------------------------------------------------------------

-- QUERY 1 Retrive all orders for a specific customer 

SELECT o.OrderID,o.OrderDate,o.TotalAmount,oi.ProductID,p.ProductName,oi.Quantity,oi.Price
From Orders o
JOIN OrderItems oi ON o.OrderID=oi.OrderID
JOIN Products p ON p.ProductID=oi.ProductID
WHERE o.CustomerID=2;

-- QUERY 2 Find the total sales of each product
SELECT  p.ProductID,p.ProductName,sum(oi.Price*oi.Quantity) as TotalSales
FROM orderitems oi
JOIN Products p ON oi.ProductID=p.ProductID
GROUP BY p.ProductID,p.ProductName
ORDER BY TotalSales asc;

-- QUERY 3 Claculate average order values
SELECT avg(TotalAmount)  as AverageSales from orders;

-- QUERY 4 List the top 5 customers by total spendings
SELECT c.CustomerID,c.FirstName,c.LastName,sum(oi.Quantity*oi.Price) AS TotalSpending,o.OrderID
FROM orderitems oi
JOIN orders o ON o.OrderID=oi.OrderID
JOIN customers c ON c.CustomerID=o.CustomerID
GROUP BY o.OrderID limit 5;

-- QUERY 5 RETRIVE THE MOST POPULAR PRODUCT CATEGORY
SELECT CategoryID,CategoryName,TotalQuantity,rn
FROM
(SELECT cg.CategoryID,cg.CategoryName,sum(oi.Quantity) as TotalQuantity,
ROW_NUMBER() over(order by sum(oi.Quantity) desc) as rn
From orderitems oi
join products p on p.ProductID=oi.ProductID
join categories cg on cg.CategoryID=p.CategoryID
group by cg.CategoryID,cg.CategoryName) sub
where rn=1;

-- QUERY 6 LIST ALL THE PRODUCTS THAT ARE OUT OF STOCK
SELECT * FROM products 
where stock=0;
-- with category name
SELECT p.ProductID,p.ProductName,c.CategoryName,p.Stock
FROM products p
join  categories c on c.CategoryID=p.CategoryID
where p.stock=0;

-- QUERY 7 FIND THE CUSTOMERS WHO HAVE PLACED ORDERS IN LAST 30 DAYS
SELECT distinct c.CustomerID,c.FirstName,c.LastName,c.Email,c.Phone
From customers c
join orders o on o.CustomerID=c.CustomerID
where o.OrderDate >= now()-interval 30 day;

-- QUERY 8 CALCULATE TOTAL NUMBER OF ORDERS PLACED EACH MONTH
SELECT  DISTINCT YEAR(OrderDate) as OrderYear,Month(OrderDate) as OrderMonth,COUNT(OrderID)as TotalOrders
FROM orders 
group by OrderYear,OrderMonth
order by  OrderYear,OrderMonth;

-- QUERY 9 RETREIVE THE DETAILS OF MOST RECENT ORDERS
SELECT o.OrderID,o.OrderDate,o.TotalAmount,c.FirstName,c.LastName
FROM orders o
join customers c on o.CustomerID=c.CustomerID
order by o.OrderDate desc limit 1 ;

-- QUERY 10 FIND THE AVERAGE PRICE OF PRODUCT IN EACH CATEGORY
SELECT c.CategoryID,c.CategoryName,avg(p.Price) as AvgPrice
From products p
join categories c on c.CategoryID=p.CategoryID 
group by c.CategoryName,c.CategoryID
order by AvgPrice DESC;

-- QUERY 11 LIST CUSTOMERS WHO HAVE NEVER PLACED ORDERS
SELECT c.CustomerID,c.FirstName,c.LastName,c.Email,c.Phone,o.OrderID,o.TotalAmount
from customers c
left join orders o on c.CustomerID=o.CustomerID
where o.OrderID IS NULL;

-- QUERY 12 RETRIVE THE TOTAL QUANTITY SOLD FOR EACH PRODUCT
SELECT p.ProductID,p.ProductName,sum(oi.Quantity) as TotalQuantitySold
FROM orderitems  oi
join products p on p.ProductID=oi.ProductID
GROUP BY  p.ProductID,p.ProductName;

-- QUERY 13 CALCULATE THE TOTAL REVENUE GENERATED FROM EACH CATEGORY
SELECT c.CategoryID,c.CategoryName,sum(oi.Price*oi.Quantity) AS TotalRevenue
FROM orderitems oi
JOIN products p on p.ProductID=oi.ProductID
JOIN categories c on c.CategoryID=p.CategoryID
GROUP BY c.CategoryID,c.CategoryName
ORDER BY TotalRevenue DESC;

-- QUERY 14 FIND THE HIGHEST PRICE PRODUCT IN EACH CATEGORY
SELECT c.CategoryID,c.CategoryName,p1.ProductID, p1.ProductName,p1.Price
FROM products p1
JOIN categories c on p1.CategoryID=c.CategoryID
WHERE p1.price=(SELECT MAX(Price) FROM Products p2 WHERE p1.CategoryID=p2.CategoryID)
ORDER BY p1.Price DESC ;

-- QUERY 15 Retrive orders with total amount greater than specific values
SELECT o.OrderID,o.CustomerID,c.FirstName,c.LastName,o.TotalAmount
FROM orders o join customers c on o.CustomerID=c.CustomerID
where o.TotalAmount>500
order by o.TotalAmount desc;

-- QUERY 16 List product along with the number of orders they appear in 
SELECT p.ProductID,p.ProductName,count(oi.OrderID) as Ordercount
FROM products p join orderitems oi on p.ProductID=oi.ProductID
GROUP BY  p.ProductID,p.ProductName
ORDER BY Ordercount DESC;

-- QUERY 17 Find the top 3 most frequently orderd products
SELECT p.ProductID,p.ProductName,count(oi.OrderID) as Ordercount
FROM products p join orderitems oi on p.ProductID=oi.ProductID
GROUP BY  p.ProductID,p.ProductName
ORDER BY Ordercount DESC limit 3;

-- QUERY 18 Calculate the total number of customers from each country
select Country,count(CustomerID) as Total_customers
from Customers 
GROUP BY  Country
ORDER BY Total_customers desc ;

-- QUERY 19 Retrive the list of customers along with their total spendings
SELECT Distinct c.CustomerID,c.FirstName,c.LastName,sum(o.TotalAmount ) as Total_spending
from customers c join orders o on c.CustomerID=o.CustomerID
GROUP BY c.CustomerID,c.FirstName,c.LastName
Order by  Total_spending  desc;

-- QUERY 20 List orders with more than specified number of items
SELECT o.OrderID ,c.CustomerID,c.FirstName,c.LastName,count(oi.OrderItemID) as NumberOfItems
FROM orders o join orderitems oi on o.OrderID=oi.OrderID
join Customers c on o.CustomerID=c.CustomerID
GROUP BY o.OrderID ,c.CustomerID,c.FirstName,c.LastName
HAVING COUNT(oi.OrderItemID)>1
ORDER BY NumberOfItems DESC;

-- ------------------------------------------------------------------------------------------------------
-- LOG MAINTAINENCE
-- ------------------------------------------------------------------------------------------------------
/*
Creating  additional queries that involve updating, deleting, and maintaining logs of these operations
in the OnlineRetailDB database.

Adding a table to keep logs of updates and deletions.

Step 1: Create a Log Table
Step 2: Create Triggers for Each Table

A. Triggers for Products Table
   -- Trigger for INSERT on Products table
   -- Trigger for UPDATE on Products table
   -- Trigger for DELETE on Products table

B. Triggers for Customer Table
   -- Trigger for INSERT on Customers table
   -- Trigger for UPDATE on Customers table
   -- Trigger for DELETE on Customers table
*/
-- ---------------------------------------------------------------------------------------------------
-- Create a Log Table
CREATE TABLE Changelog(
LogID INT PRIMARY KEY AUTO_INCREMENT ,
TableName VARCHAR(50),
Operation VARCHAR(20),
RecordID INT ,
ChangeDate DATETIME DEFAULT NOW(),
ChangedBy VARCHAR(50)
);
-- ----------------------------------------------------------------------------------------------------
-- A. Triggers for Products Table
-- ----------------------------------------------------------------------------------------------------
-- Trigger for INSERT on Products table
DELIMITER $$
CREATE  TRIGGER trg_Insert_Product
AFTER INSERT ON Products
FOR EACH ROW
BEGIN
    INSERT INTO Changelog (TableName, Operation, RecordID, ChangeDate, ChangedBy)
    VALUES ('Products', 'INSERT', NEW.ProductID, NOW(), USER());
END $$
DELIMITER ;

-- INSERTING ONE RECORD INTO PRODUCT TABLE 
INSERT INTO Products(ProductName,CategoryID,Price,Stock)
VALUES('Wireless mouse',1,4.99,20);
INSERT INTO Products(ProductName,CategoryID,Price,Stock)
VALUES('Kindle',3,20.99,50);

SELECT * FROM Products;

SELECT * FROM ChangeLog;
-- ------------------------------------------------------------------------------------
-- Trigger for UPDATE on Products table
DELIMITER $$
CREATE  TRIGGER trg_Update_Product
AFTER UPDATE ON Products
FOR EACH ROW
BEGIN
    INSERT INTO Changelog (TableName, Operation, RecordID, ChangeDate, ChangedBy)
    VALUES ('Products', 'UPDATE', NEW.ProductID, NOW(), USER());
END $$
DELIMITER ;

-- UPDATING ANY RECORD FROM PRODUCT TABLE 
UPDATE Products SET Price=499.99 where ProductID=2;
UPDATE Products SET Price=899.99 where ProductID=1;

SELECT * FROM Products;

SELECT * FROM ChangeLog;
-- -----------------------------------------------------------------------------
-- Trigger for DELETE on Products table
DELIMITER $$
CREATE TRIGGER trg_Delete_Product
AFTER DELETE ON Products
FOR EACH ROW
BEGIN
    INSERT INTO Changelog (TableName, Operation, RecordID, ChangeDate, ChangedBy)
    VALUES ('Products', 'DELETE', OLD.ProductID, NOW(), USER());
END$$
DELIMITER ;

-- DELETING PRODUCTS FROM PRODUCT TABLE
DELETE FROM Products WHERE ProductID=15;

SELECT * FROM ChangeLog;
-- ----------------------------------------------------------------------------------------
-- B. Triggers for Customer Table
-- ----------------------------------------------------------------------------------------
-- Trigger for INSERT on Customers table
DELIMITER $$
CREATE  TRIGGER trg_Insert_Customers
AFTER INSERT ON customers
FOR EACH ROW
BEGIN
    INSERT INTO Changelog (TableName, Operation, RecordID, ChangeDate, ChangedBy)
    VALUES ('Customers', 'INSERT', NEW.CustomerID, NOW(), USER());
END $$
DELIMITER ;

-- ----------------------------------------------------------------------------------------
-- Trigger for UPDATE on Customers table
DELIMITER $$
CREATE  TRIGGER trg_Update_Customers
AFTER UPDATE ON customers
FOR EACH ROW
BEGIN
    INSERT INTO Changelog (TableName, Operation, RecordID, ChangeDate, ChangedBy)
    VALUES ('Customers', 'UPDATE', NEW.CustomerID, NOW(), USER());
END $$
DELIMITER ;
-- ----------------------------------------------------------------------------------------
-- Trigger for DELETE on Customers table
DELIMITER $$
CREATE  TRIGGER trg_Delete_Customers
AFTER DELETE ON customers
FOR EACH ROW
BEGIN
    INSERT INTO Changelog (TableName, Operation, RecordID, ChangeDate, ChangedBy)
    VALUES ('Customers', 'DELETE', OLD.CustomerID, NOW(), USER());
END $$
DELIMITER ;
-- ----------------------------------------------------------------------------------------
-- INSERTING ONE RECORD INTO  CUSTOMER TABLE 
INSERT INTO Customers(FirstName, LastName, Email, Phone, Address, City, State, ZipCode, Country)
VALUES 
('Akshay', 'Khanna', 'akshay.khanna@example.com', '129-454-7990', '234 Elm St.', 'Springfield', 
'IL', '62705', 'USA'),
('Ron', 'Smith', 'ron.smith@example.com', '234-564-8902', '999 Oak St.', 'Madison', 
'WI', '53702', 'USA');
-- UPDATING ANY RECORD FROM CUSTOMER TABLE PRIMARYProductID
UPDATE Products SET Price=499.99 where ProductID=2;
-- DELETING PRODUCTS FROM CUSTOMER TABLE









-- --------------------------------------------------------------------------------------
-- PERFORMANCE OPTIMIZATION - INDEXING
-- --------------------------------------------------------------------------------------
/*
Indexes are crucial for optimizing the performance of SQL Server database,
especially for read-heavy operations like SELECT queries.
Creating indexes for the OnlineRetailDB database to improve query performance.
*/
-- -----------------------------------------------------------------------------------------------
-- A. Indexes on Product Table
-- -----------------------------------------------------------------------------------------------
-- 1. Non-Clustered Index on CategoryID: To speed up queries filtering by CategoryID
CREATE INDEX IDX_Products_CategoryID
ON Products(CategoryID ASC);
-- 2. Non-Clustered Index on Price: To speed up queries filtering or sorting by Price.
CREATE INDEX IDX_Products_Price
ON Products(Price DESC);
-- ----------------------------------------------------------------------------------------------
-- B. Indexes on Orders Table
-- ----------------------------------------------------------------------------------------------
-- 1. Non-Clustered Index on CustomerID: To speed up queries filtering by CustomerID.
CREATE INDEX IDX_Orders_CustomerID
ON orders(CustomerID ASC);
-- 2. Non-Clustered Index on OrderDate: To speed up queries filtering or sorting by OrderDate.
CREATE INDEX IDX_Orders_OrderDate
ON orders(OrderDate ASC);
-- ----------------------------------------------------------------------------------------------
-- C. Indexes on OrderItems Table
-- -----------------------------------------------------------------------------------------------
-- 1. Non-Clustered Index on OrderID: To speed up queries filtering by OrderID.
CREATE INDEX IDX_OrderItems_OrderID
ON orderitems(OrderID ASC);
-- 2. Non-Clustered Index on ProductID: To speed up queries filtering by ProductID.
CREATE INDEX IDX_OrderItems_ProductID
ON orderitems(ProductID ASC);
-- ----------------------------------------------------------------------------------------------
-- D. Indexes on Customers Table
-- -----------------------------------------------------------------------------------------------
-- 1. Non-Clustered Index on Email: To speed up queries filtering by Email.
CREATE INDEX IDX_Customes_Email
ON customers(Email);
-- 2. Non-Clustered Index on Country: To speed up queries filtering by Country.
CREATE INDEX IDX_Customers_Country
ON customers(Country ASC);
-- ------------------------------------------------------------------------------------------------
/*
-----------------------------------------------------
Implementing Views
-----------------------------------------------------
Views are virtual tables that represent the result of a query.
They can simplify complex queries and enhance security by restricting access to specific data.
*/
-- ----------------------------------------------------------------------------------------------
-- View for Product Details: A view combining product details with category names.
CREATE VIEW vw_productdetails AS
SELECT p.ProductID,p.ProductName,p.Price,p.Stock,c.CategoryName
FROM products p  INNER JOIN categories c ON p.CategoryID=c.CategoryID;
-- Displaying product detais with category name
SELECT * FROM  vw_productdetails;
-- ---------------------------------------------------------------------------------------------
-- View for Customer Orders: A view to get a summary of orders placed by each customer.
CREATE VIEW vw_OrderSummary AS
SELECT c.CustomerID,c.FirstName,c.LastName,COUNT(o.OrderID) AS TotalOrder,SUM(oi.Quantity*p.Price) as TotalAmount
FROM products p JOIN orderitems oi ON p.ProductID=oi.ProductID
JOIN orders o ON o.OrderID=oi.OrderID
JOIN customers c on c.CustomerID=o.CustomerID
GROUP BY c.CustomerID,c.FirstName,c.LastName;
-- DISPLAYING ORDER SUMMARY 
SELECT * FROM vw_OrderSummary;
-- ------------------------------------------------------------------------------------------------------
-- View for Recent Orders: A view to display orders placed in the last 30 days.
CREATE VIEW vw_RecentOrders AS
SELECT o.OrderID,o.OrderDate,c.CustomerID,c.FirstName,c.LastName,SUM(oi.Quantity*oi.Price) as OrderAmount
FROM customers c JOIN orders o ON o.CustomerID=c.CustomerID
JOIN orderitems oi ON oi.OrderID=o.OrderID
WHERE OrderDate >= CURDATE() - INTERVAL 30 DAY
GROUP BY o.OrderID,o.OrderDate,c.CustomerID,c.FirstName,c.LastName;
-- DISPLAYING ORDER SUMMARY 
SELECT * FROM vw_RecentOrders;
-- ----------------------------------------------------------------------------------------------
-- Query 31: Retrieve All Products with Category Names
-- Using the vw_ProductDetails view to get a list of all products along with their category names.
SELECT * FROM  vw_productdetails;
-- ----------------------------------------------------------------------------------------------
-- Query 32: Retrieve Products within a Specific Price Range
-- Using the vw_ProductDetails view to find products priced between $100 and $500.

SELECT * FROM  vw_productdetails
WHERE Price BETWEEN 30 AND 500;
-- ----------------------------------------------------------------------------------------------
-- Query 33: Count the Number of Products in Each Category
-- Using the vw_ProductDetails view to count the number of products in each category.

SELECT CategoryName,COUNT(*) AS ProductCount FROM  vw_productdetails
GROUP BY CategoryName;
-- ----------------------------------------------------------------------------------------------
-- Query 34: Retrieve Customers with More Than 5 Orders
-- Using the vw_OrderSummary view to find customers who have placed more than 1 orders.

SELECT * FROM vw_OrderSummary
WHERE TotalOrder >=2;
-- ----------------------------------------------------------------------------------------------
-- Query 35: Retrieve the Total Amount Spent by Each Customer
-- Using the vw_OrderSummary view to get the total amount spent by each customer.

SELECT * FROM vw_OrderSummary;
-- ----------------------------------------------------------------------------------------------
-- Query 36: Retrieve Recent Orders Above a Certain Amount
-- Using the vw_RecentOrders view to find recent orders where the total amount is greater than $500.
SELECT * FROM vw_RecentOrders
WHERE OrderAmount>500;
-- ------------------------------------------------------------------------------------------------
-- Query 37: Retrieve the Latest Order for Each Customer
-- Using the vw_RecentOrders view to find the latest order placed by each customer.

-- -----------------------------------------------------------------------------------------------
-- Query 38: Retrieve Products in a Specific Category
-- Using the vw_ProductDetails view to get all products in a specific category, such as 'Electronics'.

-- -------------------------------------------------------------------------------------------------
-- Query 39: Retrieve Total Sales for Each Category
-- Using the vw_ProductDetails and vw_CustomerOrders views to calculate the total sales for each category.

-- -------------------------------------------------------------------------------------------------
-- Query 40: Retrieve Customer Orders with Product Details
-- Using the vw_CustomerOrders and vw_ProductDetails views to get customer orders along with the details of the products.

-- -- -------------------------------------------------------------------------------------------------
-- Query 41: Retrieve Top 5 Customers by Total Spending
-- Using the vw_CustomerOrders view to find the top 5 customers based on their total spending.

-- -- -------------------------------------------------------------------------------------------------
-- Query 42: Retrieve Products with Low Stock
-- Using the vw_ProductDetails view to find products with stock below a certain threshold, such as 10 units.

-- -- -------------------------------------------------------------------------------------------------
-- Query 43: Retrieve Orders Placed in the Last 7 Days
-- Using the vw_RecentOrders view to find orders placed in the last 7 days.

-- ----------------------------------------------------------------------------------------------------
-- Query 44: Retrieve Products Sold in the Last Month
-- Using the vw_RecentOrders view to find products sold in the last month.

-- -----------------------------------------------------------------------------------------------------------