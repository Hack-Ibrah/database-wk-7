-- ### Question 1 Achieving 1NF (First Normal Form) 🛠️

-- Step 1: Create the table
CREATE TABLE ProductDetail (
    OrderID INT,
    CustomerName VARCHAR(100),
    Products VARCHAR(255)
);

-- Step 2: Insert the data
INSERT INTO ProductDetail (OrderID, CustomerName, Products) VALUES
(101, 'John Doe', 'Laptop, Mouse'),
(102, 'Jane Smith', 'Tablet, Keyboard, Mouse'),
(103, 'Emily Clark', 'Phone');

-- Step 3: Transform into 1NF - each product in its own row
SELECT 
  OrderID,
  CustomerName,
  TRIM(SUBSTRING_INDEX(Products, ',', 1)) AS Product
FROM ProductDetail

UNION ALL

SELECT 
  OrderID,
  CustomerName,
  TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(Products, ',', 2), ',', -1)) AS Product
FROM ProductDetail
WHERE LENGTH(Products) - LENGTH(REPLACE(Products, ',', '')) >= 1

UNION ALL

SELECT 
  OrderID,
  CustomerName,
  TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(Products, ',', 3), ',', -1)) AS Product
FROM ProductDetail
WHERE LENGTH(Products) - LENGTH(REPLACE(Products, ',', '')) >= 2;


-- ### Question 2 Achieving 2NF (Second Normal Form) 🧩

-- Step 1: Create the original table (1NF version)
CREATE TABLE OrderDetails (
    OrderID INT,
    CustomerName VARCHAR(100),
    Product VARCHAR(100),
    Quantity INT
);

-- Step 2: Insert the data
INSERT INTO OrderDetails (OrderID, CustomerName, Product, Quantity) VALUES
(101, 'John Doe', 'Laptop', 2),
(101, 'John Doe', 'Mouse', 1),
(102, 'Jane Smith', 'Tablet', 3),
(102, 'Jane Smith', 'Keyboard', 1),
(102, 'Jane Smith', 'Mouse', 2),
(103, 'Emily Clark', 'Phone', 1);

-- Step 3: Create the normalized table for order-level information
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerName VARCHAR(100)
);

-- Step 4: Insert distinct order-level data
INSERT INTO Orders (OrderID, CustomerName)
SELECT DISTINCT OrderID, CustomerName FROM OrderDetails;

-- Step 5: Create the order items table to remove partial dependency
CREATE TABLE OrderItems (
    OrderID INT,
    Product VARCHAR(100),
    Quantity INT,
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
);

-- Step 6: Insert item-level data
INSERT INTO OrderItems (OrderID, Product, Quantity)
SELECT OrderID, Product, Quantity FROM OrderDetails;

-- Optional: Step 7 - Verify with a JOIN (Final 2NF View)
SELECT 
    oi.OrderID,
    o.CustomerName,
    oi.Product,
    oi.Quantity
FROM OrderItems oi
JOIN Orders o ON oi.OrderID = o.OrderID;
