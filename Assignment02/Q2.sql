use mydb;

create table Product_table(
	productID int(4) AUTO_INCREMENT PRIMARY KEY,
    category char(30),
    detail varchar(30),
    price decimal(10,2),
    stock int(5)
);

insert into Product_table(productID, category, detail, price, stock)
values
(101, 'Auto', 'Vacuum cleaner', 5000.50 , 10),
(102, 'Elec', 'Mixer', 500.58 , 50),
(103, 'qwe', 'Fridge', 9000.99 , 40),
(104, 'xcvbn', 'Washing Machine', 8900.45 , 5),
(105, 'wery', 'Sofa', 14000.89 , 14),
(106, 'xcvb', 'Door', 300.56 , 9),
(107, 'poiuy', 'qqqqq', 999.99 , 6);

select * from Product_table;

delimiter //
create procedure Increase_Price(in X int(3), in Y varchar(30))
begin
  update Product_table
  set price = price + (price*X)/100
  where category = Y;
end;
//

delimiter ;

call Increase_Price(20, 'wery');
call Increase_Price(50, 'xcvb');
   