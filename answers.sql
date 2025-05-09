


-- 📝 Assignment: Database Design and Normalization

-- ==============================================================================
-- Question 1 Achieving 1NF (First Normal Form) 🛠️
-- ==============================================================================

-- Task: Transform the ProductDetail table into 1NF.
-- Original Table (Conceptual - violates 1NF due to multi-valued 'Products'):
-- OrderID | CustomerName | Products
-- --------|--------------|------------------------
-- 101     | John Doe     | Laptop, Mouse
-- 102     | Jane Smith   | Tablet, Keyboard, Mouse
-- 103     | Emily Clark  | Phone

-- Violation: The 'Products' column contains repeating groups (multiple product names in a single cell).

-- To achieve 1NF, each row should represent a single, atomic fact.
-- This means separating the products for each order into individual rows.

-- SQL Query to create the table in 1NF structure:
-- We'll call the new table OrderProducts_1NF to denote its form.
-- Note: Directly transforming the original multi-valued data into this structure
-- using a single standard SQL query is complex and often requires procedural logic
-- or non-standard functions depending on the specific database system.
-- Here, we define the correct 1NF structure and show the resulting data via INSERTs.

DROP TABLE IF EXISTS OrderProducts_1NF;

CREATE TABLE OrderProducts_1NF (
    OrderID INT,          -- Represents the unique order identifier
    CustomerName VARCHAR(100), -- Customer associated with the order
    ProductName VARCHAR(100), -- Each row contains a single product name
    -- A primary key in 1NF should uniquely identify each row.
    -- Since an order can have multiple products, the combination of OrderID and ProductName
    -- is needed to uniquely identify each row in this 1NF structure.
    PRIMARY KEY (OrderID, ProductName)
);

-- SQL Queries to insert data into the 1NF table structure:
-- These inserts represent the data from the original table after normalization to 1NF.
INSERT INTO OrderProducts_1NF (OrderID, CustomerName, ProductName) VALUES
(101, 'John Doe', 'Laptop'),
(101, 'John Doe', 'Mouse'),
(102, 'Jane Smith', 'Tablet'),
(102, 'Jane Smith', 'Keyboard'),
(102, 'Jane Smith', 'Mouse'),
(103, 'Emily Clark', 'Phone');

-- Explanation of Transformation:
-- The original single rows with multiple products in the 'Products' column
-- have been split into multiple rows, with each product now having its own row
-- associated with the original OrderID and CustomerName. The combination of
-- OrderID and ProductName forms the composite primary key, uniquely identifying
-- each record (each product item within an order).

-- ==============================================================================
-- Question 2 Achieving 2NF (Second Normal Form) 🧩
-- ==============================================================================

-- Task: Transform the OrderDetails table (already in 1NF) into 2NF.
-- Original Table (Conceptual - is in 1NF but violates 2NF due to partial dependency):
-- Assuming the table from Q1's conceptual 1NF result, but adding Quantity:
-- OrderID | CustomerName | Product | Quantity
-- --------|--------------|---------|----------
-- 101     | John Doe     | Laptop  | 2
-- 101     | John Doe     | Mouse   | 1
-- 102     | Jane Smith   | Tablet  | 3
-- 102     | Jane Smith   | Keyboard| 1
-- 102     | Jane Smith   | Mouse   | 2
-- 103     | Emily Clark  | Phone   | 1

-- Assuming the primary key for this table is (OrderID, Product) as it uniquely identifies each row.

-- Violation: The 'CustomerName' column depends only on 'OrderID' (part of the primary key),
-- not on the entire primary key (OrderID, Product). This is a partial dependency, violating 2NF.

-- To achieve 2NF, we need to remove the partial dependency by separating the data
-- that depends only on OrderID into its own table.

-- SQL Queries to create tables in 2NF structure:
-- We split the information into two tables: one for Order details and one for the items in each order.

DROP TABLE IF EXISTS OrderItems_2NF; -- Drop child table first due to foreign key
DROP TABLE IF EXISTS Orders_2NF;

CREATE TABLE Orders_2NF (
    OrderID INT PRIMARY KEY,      -- Primary key for the Orders table
    CustomerName VARCHAR(100)     -- CustomerName depends fully on OrderID
);

CREATE TABLE OrderItems_2NF (
    OrderID INT,              -- Foreign key referencing Orders_2NF
    Product VARCHAR(100),     -- Part of the composite primary key
    Quantity INT,             -- Quantity depends on the specific OrderID and Product
    -- The combination of OrderID and Product uniquely identifies each item line in an order
    PRIMARY KEY (OrderID, Product),
    -- Establish a foreign key relationship to the Orders table
    FOREIGN KEY (OrderID) REFERENCES Orders_2NF(OrderID)
);

-- SQL Queries to insert data into the 2NF table structures:
-- Insert data into the Orders_2NF table (unique OrderID and CustomerName)
INSERT INTO Orders_2NF (OrderID, CustomerName) VALUES
(101, 'John Doe'),
(102, 'Jane Smith'),
(103, 'Emily Clark');

-- Insert data into the OrderItems_2NF table (OrderID, Product, Quantity)
INSERT INTO OrderItems_2NF (OrderID, Product, Quantity) VALUES
(101, 'Laptop', 2),
(101, 'Mouse', 1),
(102, 'Tablet', 3),
(102, 'Keyboard', 1),
(102, 'Mouse', 2),
(103, 'Phone', 1);

-- Explanation of Transformation:
-- The 'CustomerName' column, which was partially dependent on the primary key (OrderID, Product)
-- because it only depended on OrderID, has been moved to a separate table (Orders_2NF)
-- where OrderID is the primary key. The OrderItems_2NF table now contains the data
-- (Product, Quantity) that fully depends on the composite primary key (OrderID, Product).
-- A foreign key constraint is added in OrderItems_2NF referencing Orders_2NF to maintain the relationship.
-- This eliminates the partial dependency, achieving 2NF
