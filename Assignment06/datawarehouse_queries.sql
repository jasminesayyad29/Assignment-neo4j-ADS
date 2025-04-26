create database CustomerOrderDataWarehouse;
use CustomerOrderDataWarehouse;

CREATE TABLE DimCustomers (
    Customer_id INT PRIMARY KEY,
    Customer_name VARCHAR(100),
    City_id INT,
    First_order_date DATE,
    Customer_type ENUM('Walk-in', 'Mail-order', 'Both')
);

CREATE TABLE DimStores (
    Store_id INT PRIMARY KEY,
    City_id INT,
    Phone VARCHAR(20)
);

CREATE TABLE DimItems (
    Item_id INT PRIMARY KEY,
    Description TEXT,
    Size VARCHAR(50),
    Weight DECIMAL(10,2),
    Unit_price DECIMAL(10,2)
);

CREATE TABLE DimCities (
    City_id INT PRIMARY KEY,
    City_name VARCHAR(100),
    State VARCHAR(50)
);
INSERT INTO DimCities (City_id, City_name, State) VALUES (101, 'Mumbai', 'MH');
INSERT INTO DimCities (City_id, City_name, State) VALUES (102, 'Sangli', 'MH');
select * from Dimcities;

CREATE TABLE DimHeadquarters (
    City_id INT PRIMARY KEY,
    Headquarter_addr VARCHAR(255),
    State VARCHAR(50)
);


CREATE TABLE FactOrders (
    Order_id INT PRIMARY KEY,
    Customer_id INT,
    Store_id INT,
    Item_id INT,
    Quantity_ordered INT,
    Ordered_price DECIMAL(10,2),
    Order_date DATE,
    FOREIGN KEY (Customer_id) REFERENCES DimCustomers(Customer_id),
    FOREIGN KEY (Store_id) REFERENCES DimStores(Store_id),
    FOREIGN KEY (Item_id) REFERENCES DimItems(Item_id)
);

/*extract customers*/
INSERT INTO DimCustomers (Customer_id, Customer_name, City_id, First_order_date, Customer_type)
SELECT 
    c.Customer_id, 
    c.Customer_name, 
    c.City_id, 
    c.First_order_date,
    CASE 
        WHEN w.Customer_id IS NOT NULL AND m.Customer_id IS NOT NULL THEN 'Both'
        WHEN w.Customer_id IS NOT NULL THEN 'Walk-in'
        WHEN m.Customer_id IS NOT NULL THEN 'Mail-order'
        ELSE NULL
    END AS Customer_type
FROM HeadquarterDB.Customer c
LEFT JOIN HeadquarterDB.Walk_in_customers w ON c.Customer_id = w.Customer_id
LEFT JOIN HeadquarterDB.Mail_order_customers m ON c.Customer_id = m.Customer_id;

select * from DimCustomers;

/*extract stores*/
INSERT INTO DimStores (Store_id, City_id, Phone)
SELECT Store_id, City_id, Phone FROM SalesDB.Stores;

select * from DimStores;

/*extract items*/
INSERT INTO DimItems (Item_id, Description, Size, Weight, Unit_price)
SELECT Item_id, Description, Size, Weight, Unit_price FROM SalesDB.Items;

select * from DimItems;

/*extarct orders*/
INSERT INTO FactOrders (Order_id, Customer_id, Store_id, Item_id, Quantity_ordered, Ordered_price, Order_date)
SELECT 
    o.Order_no, 
    o.Customer_id, 
    s.Store_id, 
    oi.Item_id, 
    oi.Quantity_ordered, 
    oi.Ordered_price, 
    o.Order_date
FROM SalesDB.Orders o
JOIN SalesDB.Ordered_item oi ON o.Order_no = oi.Order_no
JOIN SalesDB.Stores s ON s.City_id = (SELECT City_id FROM HeadquarterDB.Customer WHERE Customer_id = o.Customer_id);

select * from FactOrders;

/*Fact stock table */
CREATE TABLE FactStock (
    Store_id INT,
    Item_id INT,
    Quantity_held INT,
    FOREIGN KEY (Store_id) REFERENCES DimStores(Store_id),
    FOREIGN KEY (Item_id) REFERENCES DimItems(Item_id)
);
/*extract stock data*/
INSERT INTO FactStock (Store_id, Item_id, Quantity_held)
SELECT Store_id, Item_id, Quantity_held FROM SalesDB.Stored_items;

select * from FactStock;



/*1. Find all stores holding a particular item along with city, state, phone, and item details.*/
SELECT 
    ds.Store_id, dc.City_name, dc.State, ds.Phone, 
	di.Size, di.Weight, di.Description, di.Unit_price
FROM FactOrders fo
JOIN DimStores ds ON fo.Store_id = ds.Store_id
JOIN DimCities dc ON ds.City_id = dc.City_id
JOIN DimItems di ON fo.Item_id = di.Item_id
WHERE di.Item_id = 1002; 


/*Find all the orders along with customer name and order date that can be fulfilled by a given store.*/ 
SELECT 
    fo.Order_id, 
    dc.Customer_name, 
    fo.Order_date
FROM FactOrders fo
JOIN DimCustomers dc ON fo.Customer_id = dc.Customer_id
WHERE fo.Store_id = 11; 


/*Find all stores along with city name and phone that hold items ordered by given customer. */ 
SELECT 
	ds.Store_id, 
    dci.City_name,
    ds.Phone,
    fo.Customer_id, 
    dc.Customer_name 
FROM FactOrders fo
JOIN DimCustomers dc ON fo.Customer_id = dc.Customer_id
JOIN DimStores ds ON fo.Store_id = ds.Store_id
JOIN DimCities dci ON ds.City_id = dci.City_id
WHERE fo.Customer_id = 1  
ORDER BY dc.Customer_name;

 
/*Find the headquarter address along with city and state of all stores that hold stocks of an item above a particular level. */  
SELECT 
	si.item_id,
    dc.City_name, 
    dc.State
FROM FactStock si
JOIN DimStores ds ON si.Store_id = ds.Store_id
JOIN DimCities dc ON ds.City_id = dc.City_id
WHERE si.Quantity_held > 20; 


/*For each customer order, show the items ordered along with description, store id and city name and the stores that hold the items. */
SELECT 
    fo.Order_id,
    dc.Customer_name,
    fo.Order_date,
    di.Item_id,
    di.Description,
    ds.Store_id,
    dcity.City_name
FROM FactOrders fo
JOIN DimCustomers dc ON fo.Customer_id = dc.Customer_id
JOIN DimItems di ON fo.Item_id = di.Item_id
JOIN DimStores ds ON fo.Store_id = ds.Store_id
JOIN DimCities dcity ON ds.City_id = dcity.City_id
ORDER BY fo.Order_id;  


/*Find the city and the state in which a given customer lives. */
Select 
	dcus.customer_name,
	dc.city_id,
    dc.city_name,
    dc.state
from DimCustomers dcus
join DimCities dc on dcus.city_id = dc.city_id
where customer_id = 1;
 
 
/*Find the stock level of a particular item in all stores in a particular city. */
SELECT 
    ds.Store_id, 
    dc.City_name, 
    si.Item_id, 
    di.Description, 
    si.Quantity_held
FROM FactStock si
JOIN DimStores ds ON si.Store_id = ds.Store_id
JOIN DimCities dc ON ds.City_id = dc.City_id
JOIN DimItems di ON si.Item_id = di.Item_id
WHERE si.Item_id = 1001 
AND dc.City_name = 'Mumbai'; 


/*Find the items, quantity ordered, customer, store and city of an order. */
SELECT 
    di.Item_id,
    di.Description, 
    fo.Quantity_ordered, 
    fo.Store_id, 
    dc.Customer_name, 
    dcity.City_name
FROM FactOrders fo
JOIN DimItems di ON fo.Item_id = di.Item_id
JOIN DimCustomers dc ON fo.Customer_id = dc.Customer_id
JOIN DimStores ds ON fo.Store_id = ds.Store_id  
JOIN DimCities dcity ON ds.City_id = dcity.City_id; 

    
/*Find the walk in customers, mail order customers and dual customers (both walk-in and mail order). */	
SELECT 
	Customer_id,
    Customer_name,
    Customer_type
from DimCustomers;



















