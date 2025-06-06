create database E_Commerce_System;

use E_Commerce_System;


create table Producttable(
ProductID INT primary key auto_increment,
ProductName varchar(100),
Category varchar (50),
Price decimal(10,2),
StockQuntity int not null
);

 

insert into Producttable(ProductName,Category,Price,StockQuntity)
values('Laptop','Electronice',45000.00,50),
('Smartphone','Electronice',20000.00,60),
('Headphone','Accessories',1500.00,100),
('Camera','Electronice',25000.00,80),
('Speaker','Accessories',1800.00,35);



create table Customers(
CustomerID INT primary key auto_increment,
FirstName varchar (50),
LastName varchar (50),
Email varchar (20),
PhoneNumber bigint,
Address varchar(30)
);

insert into Customers(FirstName, LastName ,Email, PhoneNumber, Address)
values('Kabir','Singh','kabir@gmail.com',7021351147,'Mumbai'),
('Hitesh','Nrupnarayan','Hitz@gmail.com','9619432453','Pune'),
('Sourav','Kajania','sourav@gamil.com',9619432463,'Delhi'),
('Sweta','Kumari','Sweta@gamil.com',9619432466,'Bihar'),
('Payal','Chauhan','piyu@gmail.com',8080543277,'Bangalore');


create table Orders(
OrderID int primary key auto_increment,
CustomerID int,
OrderDate timestamp default current_timestamp,
TotalAmount decimal(10,2),
OrderStatus ENUM('Pending','Shipped','Delivered','Cancelled'),
foreign key (CustomerID) references Customers(CustomerID)
);

insert into Orders(CustomerID,TotalAmount, OrderStatus)
VALUES (1, 1150.00, 'Pending'),
(2, 400.00, 'Shipped'),
(3, 200.00, 'Delivered');


create table OrderDetails (
OrderDetailID int primary key auto_increment,
OrderID int,
ProductID int,
Quantity int not null,
UnitPrice decimal(10,2) not null,
Subtotal decimal(10,2),
foreign key (OrderID) REFERENCES Orders(OrderID) ,
foreign key (ProductID) REFERENCES Producttable(ProductID)
);
drop table OrderDetails;
insert into OrderDetails (OrderID, ProductID, Quantity, UnitPrice, Subtotal) 
values 
(1, 1, 1, 750.00, 750.00),
(1, 3, 2, 50.00, 100.00),
(2, 2, 1, 400.00, 400.00),
(3, 4, 2, 100.00, 200.00);



select ProductName, Category, Price, StockQuntity
from Producttable
where StockQuntity > 0;


select O.OrderID, O.OrderDate, PT.ProductName, OD.Quantity, OD.UnitPrice, OD.Subtotal
from Orders O
join OrderDetails OD on O.OrderID = OD.OrderID
join Producttable PT on OD.ProductID = PT.ProductID
where O.CustomerID = 1;

 -- creating reviews table and inserting values
 
create table Reviews(
    ReviewID int primary key auto_increment,
    CustomerID int,
    ProductID int,
    Rating int check (Rating BETWEEN 1 AND 5),
    comment text,
    ReviewDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
 foreign key (CustomerID) REFERENCES Customers(CustomerID),
foreign key (ProductID) REFERENCES Producttable(ProductID)
);

insert into Reviews (CustomerID, ProductID, Rating, Comment) 
VALUES 
(1, 1, 5, 'Excellent Laptop!'),
(2, 2, 4, 'Good smartphone, but battery life is average.'),
(3, 3, 5, 'Great sound quality!');



select PT.ProductName, avg(R.Rating) as AverageRating
from Producttable PT
join Reviews R on PT.ProductID = R.ProductID
group by PT.ProductID
order by AverageRating DESC
limit 5;



select PT.ProductName, SUM(OD.Subtotal) as TotalRevenue
from OrderDetails OD
join Orders O on OD.OrderID = O.OrderID
join Producttable PT on OD.ProductID = PT.ProductID
where O.OrderDate >= DATE_SUB(CURRENT_DATE, INTERVAL 1 MONTH)
group by  PT.ProductID
order by TotalRevenue DESC;

create index idx_product_id on OrderDetails(ProductID);
create index idx_customer_id on Orders(CustomerID);
create index idx_order_date on Orders(OrderDate);
create index idx_email on Customers(Email);
