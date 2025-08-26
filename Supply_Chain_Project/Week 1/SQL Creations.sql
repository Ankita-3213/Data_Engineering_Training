create database supply_chain;

use supply_chain;

-- Creating suppliers, inventory orders tables
create table suppliers(
supplier_id int primary key auto_increment,
name varchar(75), email varchar(75));

create table inventory(
item_id int primary key auto_increment,
item_name varchar(75), supplier_id int, reorder_level int,
foreign key(supplier_id) references suppliers(supplier_id));

create table orders(
order_id int primary key auto_increment,
item_id int, quantity int, order_date date, status varchar(45),
foreign key (item_id) references inventory(item_id));

-- Inserting data into tables
insert into suppliers(name, email) values
('Sheldon Cooper', 'sheldon@bazinga.com'),
('Amy', 'amy@bazinga.com'),
('Leonard Hofstader', 'leonard@bazinga.com'),
('Penny', 'penny@bazinga.com'),
('Howard Wolowitz', 'howard@bazinga.com'),
('Bernadette', 'bernadette@bazinga.com'),
('Raj', 'raj@bazinga.com');

insert into inventory (item_name, supplier_id, reorder_level) values
('Quantum Physics Book', 1, 10),
('Neuroscience Journal', 2, 5),
('Laser Pointer', 3, 8),
('Acting Guides', 4 ,5),
('Engineering toolkit', 5, 6),
('Microbiology Journal', 6, 3),
('Astronomy Telescope', 7, 8);

insert into orders (item_id, quantity, order_date, status) values
(1, 5, '2025-08-02', 'Pending'),
(2, 3, '2025-08-23', 'Shipped'),        
(3, 10, '2025-08-22', 'Delivered'),     
(4, 2, '2025-08-21', 'Pending'),        
(5, 1, '2025-08-20', 'Cancelled');

ALTER TABLE inventory ADD COLUMN quantity INT DEFAULT 20;

-- CRUD Operations
insert into orders(item_id, quantity, order_date, status) values
(1, 6, '2025-08-08', 'Shipped'),
(7, 4, '2025-08-08', 'Pending');

select * from inventory;
select o.order_id, i.item_name, o.quantity, o.status, o.order_date
from orders o
join inventory i 
on o.item_id = i.item_id;

update orders set status = 'Shipped' where order_id = 1;

delete from orders where order_id = 5;

-- Auto reorder trigger
delimiter //
create trigger trg_auto_reorder
after update on inventory
for each row
begin
	if new.quantity < new.reorder_level then
    insert into orders (item_id, quantity, order_date, status) values
    (new.item_id, 50, curdate(), 'Pending');
    end if;
end;
//
delimiter ;

