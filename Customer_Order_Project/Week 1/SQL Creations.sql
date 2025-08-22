create database customer_orders;
use customer_orders;

-- Creating tables : customers, orders and delivary_status
-- customers table
create table customers( customer_id int primary key auto_increment, 
name varchar (50), 
email varchar (50), 
region varchar (50)
);

-- orders table
create table orders(
order_id int primary key auto_increment,
customer_id int,
order_date datetime,
total_amount decimal (10,2),
foreign key (customer_id) references customers(customer_id)
);

-- orders table
create table orders(
order_id int primary key auto_increment,
customer_id int,
order_date datetime,
total_amount decimal(10,2),
foreign key (customer_id) references customers(customer_id)
);

ALTER TABLE orders
ADD COLUMN status VARCHAR(30) DEFAULT 'PLACED';
select * from orders;

-- delivery_status
create table delivery_status(
delivery_id int primary key auto_increment,
order_id int,
delivery_status varchar(50),
updated_on datetime,
foreign key (order_id) references orders(order_id)
);

-- Inserting data into tables
insert into customers(name, email, region) values
('Claire Dunphy', 'claire@example.com', 'East'),
('Phil Dunphy', 'realtorphil@example.com', 'East'),
('Jay Prichette', 'jay@example.com', 'North'),
('Gloria Prichette', 'gloria@example.com', 'North'),
('Mitchel Prichette', 'lawyermitch@example.com', 'South'),
('Cameron Tucker', 'cam@example.com', 'South'),
('Haley Dunphy', 'haley@example.com', 'West'),
('Dylan Marshall', 'dylan@example.com', 'West');

insert into orders(customer_id, order_date, total_amount, status) values
(1, '2025-08-01', 2500.00, 'DELIVERED'),
(2, '2025-08-05', 1800.00, 'SHIPPED'),
(3, '2025-08-02', 3200.00, 'DELIVERED'),
(4, '2025-08-10', 1450.00, 'IN_TRANSIT'),
(5, '2025-08-15', 2200.00, 'PLACED'),
(6, '2025-08-07', 2750.00, 'DELIVERED'),
(7, '2025-08-18', 900.00, 'PLACED'),
(8, '2025-08-12', 1100.00, 'IN_TRANSIT');

INSERT INTO delivery_status (order_id, delivery_status, updated_on) VALUES
(1, 'DELIVERED', '2025-08-05'),
(2, 'IN_TRANSIT', '2025-08-06'),
(3, 'DELIVERED', '2025-08-03'),
(4, 'IN_TRANSIT', '2025-08-11'),
(5, 'PLACED', '2025-08-15'),
(6, 'DELIVERED', '2025-08-08'),
(7, 'PLACED', '2025-08-18'),
(8, 'IN_TRANSIT', '2025-08-13');

-- Perform CRUD operations
insert into orders(customer_id, order_date, total_amount, status) values
(1, '2025-08-15', 1500.0, 'PLACED'),
(5, '2025-08-14', 2100.0, 'IN_TRANSIT');

select * from orders;
select * from delivery_status;

update orders set status = 'IN_TRANSIT' where order_id = 9;

delete from orders where order_id = 10;

-- Stored Procedure for Delayed deliveries
DELIMITER $$
Create procedure DelayedDelivery(IN cust_id int)
BEGIN
	select o.order_id, o.order_date, o.status as order_status,
    d.delivery_status, d.updated_on
    from orders o join delivery_status d 
    on o.order_id = d.order_id
    where o.customer_id = cust_id
    and d.delivery_status !='DELIVERED';
END $$
DELIMITER ;

CALL DelayedDelivery(2);
