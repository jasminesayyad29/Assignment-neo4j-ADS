CREATE DATABASE HeadquarterDB;
USE HeadquarterDB;


CREATE TABLE Customer (
    Customer_id INT PRIMARY KEY,
    Customer_name VARCHAR(100),
    City_id INT,
    First_order_date DATE
);

CREATE TABLE Walk_in_customers (
    Customer_id INT PRIMARY KEY,
    Tourism_guide VARCHAR(100),
    Time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (Customer_id) REFERENCES Customer(Customer_id)
);

CREATE TABLE Mail_order_customers (
    Customer_id INT PRIMARY KEY,
    Post_address VARCHAR(255),
    Time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (Customer_id) REFERENCES Customer(Customer_id)
);


INSERT INTO Customer VALUES (1, 'Anjali Kumbhar', 101, '2025-02-20');
INSERT INTO Customer VALUES (2, 'Mihika Rajput', 102, '2025-02-25');

INSERT INTO Walk_in_customers VALUES (1, 'Jasmine Sayyad', NOW());
INSERT INTO Mail_order_customers VALUES (2, 'Vijaynagar, at post', NOW());

select * from Customer;
select * from Walk_in_customers;
select * from Mail_order_customers;

CREATE DATABASE SalesDB;
USE SalesDB;

CREATE TABLE Headquarters (
    City_id INT PRIMARY KEY,
    City_name VARCHAR(100),
    Headquarter_addr VARCHAR(255),
    State VARCHAR(50),
    Time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE Stores (
    Store_id INT PRIMARY KEY,
    City_id INT,
    Phone VARCHAR(20),
    Time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (City_id) REFERENCES Headquarters(City_id)
);

CREATE TABLE Items (
    Item_id INT PRIMARY KEY,
    Description TEXT,
    Size VARCHAR(50),
    Weight DECIMAL(10,2),
    Unit_price DECIMAL(10,2),
    Time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE Stored_items (
    Store_id INT,
    Item_id INT,
    Quantity_held INT,
    Time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (Store_id, Item_id),
    FOREIGN KEY (Store_id) REFERENCES Stores(Store_id),
    FOREIGN KEY (Item_id) REFERENCES Items(Item_id)
);

CREATE TABLE Orders (
    Order_no INT PRIMARY KEY,
    Order_date DATE,
    Customer_id INT,
    FOREIGN KEY (Customer_id) REFERENCES HeadquarterDB.Customer(Customer_id)
);

CREATE TABLE Ordered_item (
    Order_no INT,
    Item_id INT,
    Quantity_ordered INT,
    Ordered_price DECIMAL(10,2),
    Time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (Order_no, Item_id),
    FOREIGN KEY (Order_no) REFERENCES Orders(Order_no),
    FOREIGN KEY (Item_id) REFERENCES Items(Item_id)
);

INSERT INTO Headquarters VALUES (101, 'Mumbai', 'MG Road 123', 'NY', NOW());
INSERT INTO Headquarters VALUES (102, 'Sangli', 'At post 2334', 'CA', NOW());

INSERT INTO Stores VALUES (10, 101, '1234567890', NOW());
INSERT INTO Stores VALUES (11, 102, '9876543210', NOW());

INSERT INTO Items VALUES (1001, 'Laptop', '14.5 inch', 1.5, 1200.00, NOW());
INSERT INTO Items VALUES (1002, 'Mobile', '2.93 inch', 0.5, 800.00, NOW());

INSERT INTO Stored_items VALUES (10, 1001, 50, NOW());
INSERT INTO Stored_items VALUES (11, 1002, 30, NOW());

INSERT INTO Orders VALUES (5001, '2024-02-01', 1);
INSERT INTO Orders VALUES (5002, '2024-02-02', 2);

INSERT INTO Ordered_item VALUES (5001, 1001, 2, 54000.00, NOW());
INSERT INTO Ordered_item VALUES (5002, 1002, 1, 20000.00, NOW());

select * from Headquarters;
select * from Stores;
select * from Items;
select * from Stored_items;
select * from Orders;
select * from Ordered_item;

