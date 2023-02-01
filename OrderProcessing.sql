create database order_processing;
use order_processing;

create table if not exists Customers (
	cust_id int primary key,
	cname varchar(35) not null,
	city varchar(35) not null
);

create table if not exists Orders (
	order_id int primary key,
	odate date not null,
	cust_id int,
	order_amt int not null,
	foreign key (cust_id) references Customers(cust_id) on delete cascade
);

create table if not exists Items (
	item_id  int primary key,
	unitprice int not null
);

create table if not exists OrderItems (
	order_id int not null,
	item_id int not null,
	qty int not null,
	foreign key (order_id) references Orders(order_id) on delete cascade,
	foreign key (item_id) references Items(item_id) on delete cascade
);

create table if not exists Warehouses (
	warehouse_id int primary key,
	city varchar(35) not null
);

create table if not exists Shipments (
	order_id int not null,
	warehouse_id int not null,
	ship_date date not null,
	foreign key (order_id) references Orders(order_id) on delete cascade,
	foreign key (warehouse_id) references Warehouses(warehouse_id) on delete cascade
);

INSERT INTO Customers VALUES
(0001, "Customer_1", "Mysuru"),
(0002, "Customer_2", "Bengaluru"),
(0003, "Kumar", "Mumbai"),
(0004, "Customer_4", "Dehli"),
(0005, "Customer_5", "Bengaluru");

INSERT INTO Orders VALUES
(001, "2020-01-14", 0001, 2000),
(002, "2021-04-13", 0002, 500),
(003, "2019-10-02", 0005, 2500),
(004, "2019-05-12", 0003, 1000),
(005, "2020-12-23", 0004, 1200);

INSERT INTO Items VALUES
(0001, 400),
(0002, 200),
(0003, 1000),
(0004, 100),
(0005, 500);

INSERT INTO Warehouses VALUES
(0001, "Mysuru"),
(0002, "Bengaluru"),
(0003, "Mumbai"),
(0004, "Dehli"),
(0005, "Chennai");

INSERT INTO OrderItems VALUES 
(001, 0001, 5),
(002, 0005, 1),
(003, 0005, 5),
(004, 0003, 1),
(005, 0004, 12);

INSERT INTO Shipments VALUES
(001, 0002, "2020-01-16"),
(002, 0001, "2021-04-14"),
(003, 0004, "2019-10-07"),
(004, 0003, "2019-05-16"),
(005, 0005, "2020-12-23");

- #List the Warehouse information from which the Customer named "Kumar" was supplied his orders. Produce a listing of Order#, Warehouse#
select order_id,warehouse_id from Shipments where order_id=(select order_id from Orders where cust_id=(select cust_id from Customers where cname="Kumar"));

select Customers.cust_id,count(distinct Orders.order_id),Orders.order_amt from Customers ,Orders where Orders.cust_id=Customers.cust_id group by order_id;

create or replace view os as select order_id,ship_date from Shipments where warehouse_id=2;

select max(unitprice) from Items;

select * from os;

DELIMITER //
CREATE TRIGGER PreventWarehouseDelete
	BEFORE DELETE ON Warehouses
    FOR EACH ROW
    BEGIN 
		IF OLD.warehouse_id IN (SELECT warehouse_id FROM Warehouses NATURAL JOIN Shipments) THEN
			SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'An item has to be shipped from this warehouse!';
		END IF;
	END//;
DELIMITER ;

drop trigger PreventWarehouseDelete;

DELETE FROM Warehouses WHERE warehouse_id = 2;

