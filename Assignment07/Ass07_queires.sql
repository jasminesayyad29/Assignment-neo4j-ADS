
CREATE DATABASE ass7_db;
USE ass7_db;


CREATE TABLE DimProduct (
    ProductKey INT PRIMARY KEY,
    ProductAltKey VARCHAR(50),
    ProductName VARCHAR(255),
    ProductCost DECIMAL(10,2)
);

CREATE TABLE DimCustomer (
    CustomerID INT PRIMARY KEY,
    CustomerAltID VARCHAR(50),
    CustomerName VARCHAR(255),
    Gender VARCHAR(10)
);

CREATE TABLE DimStores (
    StoreID INT PRIMARY KEY,
    StoreAltID VARCHAR(50),
    StoreName VARCHAR(255),
    StoreLocation VARCHAR(255),
    City VARCHAR(100),
    State VARCHAR(100),
    Country VARCHAR(100)
);

CREATE TABLE DimDate (
    date_id INT PRIMARY KEY,
    sales_date DATE,
    day_of_week VARCHAR(10),
    month VARCHAR(10),
    quarter VARCHAR(10),
    year INT,
    public_holidays VARCHAR(255)
);

CREATE TABLE DimTime (
    TimeKey INT PRIMARY KEY,
    TimeAltKey VARCHAR(50),
    Time30 INT,
    Hour30 INT,
    MinuteNumber INT,
    SecondNumber INT,
    TimeInSecond INT,
    HourlyBucket VARCHAR(50),
    DayTimeBucketGroupKey VARCHAR(50),
    DayTimeBucket VARCHAR(50)
);

CREATE TABLE DimSalesPerson (
    SalesPersonID INT PRIMARY KEY,
    SalesPersonAltID VARCHAR(50),
    SalesPersonName VARCHAR(255),
    StoreID INT,
    City VARCHAR(100),
    State VARCHAR(100),
    Country VARCHAR(100),
    FOREIGN KEY (StoreID) REFERENCES DimStores(StoreID)
);

CREATE TABLE FactProductSales (
    TransactionID INT PRIMARY KEY,
    SalesInvoiceNumber VARCHAR(50),
    SalesDateKey INT,
    SalesTimeKey INT,
    SalesTimeAltKey VARCHAR(50), 
    StoreID INT,
    CustomerID INT,
    ProductID INT,
    SalesPersonID INT,
    Quantity INT,
    TotalAmount DECIMAL(10,2),
    DateKey INT,
    TimeKey INT,
    FOREIGN KEY (SalesDateKey) REFERENCES DimDate(date_id),
    FOREIGN KEY (SalesTimeKey) REFERENCES DimTime(TimeKey),
    FOREIGN KEY (StoreID) REFERENCES DimStores(StoreID),
    FOREIGN KEY (CustomerID) REFERENCES DimCustomer(CustomerID),
    FOREIGN KEY (ProductID) REFERENCES DimProduct(ProductKey),
    FOREIGN KEY (SalesPersonID) REFERENCES DimSalesPerson(SalesPersonID)
);

-- Insert data
INSERT INTO DimProduct VALUES (1, 'P001', 'Laptop', 1000.00);
INSERT INTO DimProduct VALUES (2, 'P002', 'T-shirt', 20.00);
INSERT INTO DimProduct VALUES (3, 'P003', 'Smartphone', 750.00);
INSERT INTO DimProduct VALUES (6, 'P003', 'Refrigerator', 40000);
INSERT INTO DimProduct VALUES (4, 'P004', 'Washing Machine', 25000);
INSERT INTO DimProduct VALUES (5, 'P005', 'Headphones', 2000);

INSERT INTO DimCustomer VALUES (1, 'C001', 'Rajesh Kumar', 'Male');
INSERT INTO DimCustomer VALUES (2, 'C002', 'Priya Sharma', 'Female');
INSERT INTO DimCustomer VALUES (3, 'C003', 'Amit Verma', 'Male');
INSERT INTO DimCustomer VALUES (4, 'C004', 'Sneha Reddy', 'Female');
INSERT INTO DimCustomer VALUES (5, 'C005', 'Vikram Singh', 'Male');

INSERT INTO DimStores VALUES (1, 'S001', 'X-Mart Downtown', 'Downtown', 'Mumbai', 'Maharashtra', 'India');
INSERT INTO DimStores VALUES (2, 'S002', 'X-Mart Mall', 'Mall', 'Delhi', 'Delhi', 'India');
INSERT INTO DimStores VALUES (3, 'S003', 'Vijay Sales', 'Brigade Road', 'Bengaluru', 'Karnataka', 'India'),
(4, 'S004', 'Spencer Retail', 'Park Street', 'Kolkata', 'West Bengal', 'India'),
(5, 'S005', 'Big Bazaar', 'Anna Salai', 'Chennai', 'Tamil Nadu', 'India');

INSERT INTO DimDate VALUES (1, '2024-03-01', 'Monday', 'March', 'Q1', 2024, 'None');
INSERT INTO DimDate VALUES (2, '2024-03-02', 'Tuesday', 'March', 'Q1', 2024, 'None');
INSERT INTO DimDate VALUES (3, '2024-08-11', 'Thursday', 'august', 'Q3', 2024, 'None');
INSERT INTO DimDate VALUES (4, '2023-04-07', 'friday', 'april', 'Q2', 2023, 'None');
INSERT INTO DimDate VALUES (5, '2025-01-12', 'sunday', 'january', 'Q1', 2025, 'yes');

INSERT INTO DimTime VALUES (1, 'T001', 8, 0, 0, 0, 28800, 'Morning', 'Group1', 'Daytime');
INSERT INTO DimTime VALUES (2, 'T002', 12, 0, 0, 0, 43200, 'Afternoon', 'Group2', 'Daytime');
INSERT INTO DimTime VALUES (3, 'T003', 18, 18, 30, 0, 66600, 'Evening', 'Group3', 'Daytime');

INSERT INTO DimSalesPerson VALUES (1, 'SP001', 'Aarav Kumar', 1, 'Mumbai', 'Maharashtra', 'India');
INSERT INTO DimSalesPerson VALUES (2, 'SP002', 'Priya Sharma', 2, 'Delhi', 'Delhi', 'India');
INSERT INTO DimSalesPerson VALUES (3, 'SP001', 'Arjun Nair', 1, 'Mumbai', 'Maharashtra', 'India'),
(6, 'SP002', 'Kavya Iyer', 2, 'Delhi', 'Delhi', 'India'),
(7, 'SP003', 'Rohan Gupta', 3, 'Bengaluru', 'Karnataka', 'India'),
(4, 'SP004', 'Neha Kapoor', 4, 'Kolkata', 'West Bengal', 'India'),
(5, 'SP005', 'Vikas Reddy', 5, 'Chennai', 'Tamil Nadu', 'India');
UPDATE DimSalesPerson  
SET SalesPersonAltID = 'SP006'  
WHERE SalesPersonID = 3;
UPDATE DimSalesPerson  
SET SalesPersonAltID = 'SP007'  
WHERE SalesPersonID = 6;
select * from DimSalesPerson;

INSERT INTO FactProductSales VALUES (1, 'INV-001', 1, 1, 'T001', 1, 1, 1, 1, 2, 2000.00, 1, 1);
INSERT INTO FactProductSales VALUES (2, 'INV-002', 2, 2, 'T002', 2, 2, 2, 2, 3, 60.00, 2, 2);
INSERT INTO FactProductSales VALUES (3, 'INV-1003', 3, 3, 'T003', 3, 3, 3, 3, 1, 40000, 3, 3),
(4, 'INV-1004', 1, 2, 'T002', 4, 4, 4, 4, 2, 50000, 1, 2),
(5, 'INV-1005', 2, 1, 'T001', 5, 5, 5, 5, 3, 6000, 2, 1);


SELECT d.sales_date, p.ProductName, SUM(f.TotalAmount) AS Total_Sales
FROM FactProductSales f
JOIN DimDate d ON f.SalesDateKey = d.date_id
JOIN DimProduct p ON f.ProductID = p.ProductKey
WHERE d.sales_date = '2024-03-01'
GROUP BY d.sales_date, p.ProductName;

-- store generateing the highest revenue
SELECT s.StoreName, SUM(f.TotalAmount) AS Total_Sales
FROM FactProductSales f
JOIN DimStores s ON f.StoreID = s.StoreID
GROUP BY s.StoreName
order by total_sales desc;

-- months generating the most sales
SELECT d.month, SUM(f.TotalAmount) AS Total_Sales
FROM FactProductSales f
JOIN DimDate d ON f.SalesDateKey = d.date_id
GROUP BY d.month;

-- Find Most Profitable Cities
SELECT s.City, SUM(f.TotalAmount) AS Total_Sales
FROM FactProductSales f
JOIN DimStores s ON f.StoreID = s.StoreID
GROUP BY s.City
ORDER BY Total_Sales DESC;

-- Best Salesperson by Revenue
SELECT sp.SalesPersonName, s.StoreName, SUM(f.TotalAmount) AS Total_Sales
FROM FactProductSales f
JOIN DimSalesPerson sp ON f.SalesPersonID = sp.SalesPersonID
JOIN DimStores s ON sp.StoreID = s.StoreID
GROUP BY sp.SalesPersonName, s.StoreName
ORDER BY Total_Sales DESC
LIMIT 5;




