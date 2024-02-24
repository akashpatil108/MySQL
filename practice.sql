-- Creating a database
Create database Topper;

-- use the created database
use topper;

-- Create the table 
create table Customer(
ID INT NOT null primary key	,
NAME varchar(25) NOT NULL,
AGE INT NOT NULL,
ADDRESS VARCHAR(30),
SALARY DECIMAL(18,2)
);

-- CREATING ANOTHER TABLE
CREATE TABLE Address(
name varchar(30) not null primary key,
city varchar(20),
dist varchar(20),
state varchar(20) not null 
);

-- DROP THE address table 
DROP TABLE address;

-- INsert the values into the Customer table 
insert into Customer (ID,NAME,AGE,ADDRESS,SALARY) VALUES (1,'Ramesh', 32, 'Ahamadabad',2000.00);
insert into Customer VAlues (2,'khilan', 25, 'Delhi',1500.00);
Insert into Customer VALUES (3,'kaushik',23,'kota',2000.00),
							(4,'Chaitali',25,'Mumbai',6500.00),
                            (5,'Hardik',27,'Bhopal',8500.00),
                            (6,'Komal',22,'MP',4500.00);
SELECT * FROM Customer;
insert into Customer values (7,'Muffy',24,'Indore',10000.00);

-- SELECT the Quary

SELECT * FROM CUstomer;
SELECT ID,Name,Salary FROM Customer;

-- USE the where clause
SELECT ID,Name,Address,Salary 
FROM Customer
WHERE Salary > 2000;

SELECT * 
FROM Customer 
WHere Name like 'C%';

SELECT * FROM Customer 
WHere Address rlike '^[abc]';
-- with AND , OR
SELECT * FROM Customer 
WHere Address rlike '^[abc]' and  Name rlike '^[MNO]|[pqr]';

select * from Customer 
where Address like 'M%' and (Salary > 5000 or Age < 25); 

select * from Customer 
where Salary > 2000 and Age > 25;

select * from Customer 
where Salary > 2000 or Age > 25;

-- UPDATE quary
update Customer
set Address='Pune'
Where ID=6;
/* if we are not use the where clause in the update then it will update the all records from the column*/

-- DELETE quary

DELETE FROM Customer 
where ID=7;

insert into Customer value (7,'Muffy', 22,'Indore',10000.00);

-- like 
/*Select the name which salary starts from the 4 */ 
SELECT * FROM Customer 
where Salary like '4%';
/*select the customer whose salary second degit is 5 and end with 0 */
select * from Customer 
where Salary like '_5%0';
/* select the customer whose salary is in five digit 
*/
select * from Customer
where Salary like '____0%'; 

select * from Customer
where Salary like '200%'; 

-- Order by clause 
SELECT * FROM Customer ORDER BY Salary desc,Name asc;

-- Group by clause
SELECT 
    max(Age) as max_age,Address,min(Salary) as min_salary
FROM
    Customer
GROUP BY 
	Address
Order by
	max_age,min_salary;

SELECT distinct Salary from Customer;

create table Orders (
OID INT primary key,
Date Datetime ,
Customer_ID INT,
Amount INT ,
Foreign key (Customer_ID) references Customer(ID));
INsert into Orders Values (102,"2009-10-08",3,3000),
							(100,"2009-10-08",3,1500),
                            (101,"2009-11-20",2,1560),
                            (103,"2008-05-20",4,2060);
                            
Select * From ORDERS;

-- Alias Query
select c.ID as customer_id,c.name as customer_name,c.age as customer_age,o.amount as order_amount,date(o.date) as Order_date
from Customer as c,Orders as o
where c.id = o.customer_id;

-- union clause
-- JoIN 
select c.ID,c.name,o.amount,o.date from Customer  c
Left join Orders  o
on c.id=o.customer_id
union 
Select c.ID,c.name,o.amount,o.date from Orders  o
left join Customer c
on c.id=o.customer_id;

-- union all clause
select c.ID,c.name,o.amount,o.date from Customer  c
Left join Orders  o
on c.id=o.customer_id
union all
Select c.ID,c.name,o.amount,o.date from Orders  o
left join Customer c
on c.id=o.customer_id;

SELECT 
    c.ID, c.name, o.amount, o.date
FROM
    Customer c
        INNER JOIN
    Orders o ON c.id = o.customer_id;

SELECT 
    c.ID, c.name, o.amount, o.date
FROM
    Orders o
        LEFT JOIN
    Customer c ON c.id = o.customer_id;
/* Difference between union, and , or , union all */
Select * from Customer 
where salary >2000
union
select * from Customer 
where age > 25;

Select * from Customer 
where salary >2000 and age>25;

Select * from Customer 
where salary >2000 or age>25;

Select * from Customer 
where salary >2000
union all
select * from Customer 
where age > 25;

-- joins 
-- left join 
SELECT 
    *
FROM
   Customer c
        LEFT JOIN
    Orders o ON c.id=o.customer_id ;  

-- right join 
SELECT 
    *
FROM
    Customer c
        right JOIN
    orders o ON c.id = o.customer_id;

/* there is no full join innthe mysql for the full join use the left join,right join and union for the full join in the mysql*/
-- cross join
SELECT 
    *
FROM
    Customer c
        cross JOIN
    orders o ;
    
ALTER table Customer
modify salary decimal(18,2) not null; 
ALTER table Customer
modify salary decimal(18,2) default 5000;
ALTER table Customer
alter column salary drop default;

insert into Customer values (8,'mina',24,'pune',1000);

delete from customer
where id=8;

alter table customer 
change column name  customer_name varchar(50) not null;

alter table customer 
rename column customer_name to name;

-- view 
Create view order_view as
select c.name, c.age,o.date,o.oid
from orders o,customer c;

select * from order_view;

drop view order_view;

Create view order_view as
select c.name, c.age,o.date,o.oid
from orders o,customer c
where o.customer_id=c.id;

select * from order_view;

select c.name, c.age,o.date,o.oid
from orders o
right join customer c
on o.customer_id=c.id;

create view customer_order_amount as
select sum(o.amount) as total_amount, c.name as customer_name
from Orders o, customer c
where o.customer_id=c.id
group by c.name
order by total_amount asc;

select * from customer_order_amount;

-- 2nd or Nth highest/lowest salary
select salary from customer
order by salary desc # for the highest values use descending for the lowest use ascending
limit 1,1;  # for the nth highest use here n-1,1

select avg(Age) from customer;
SET SQL_SAFE_UPDATES = 0; # to turn off the safe update mode(0 - off,1 - on)
-- update address pune is null
update  customer 
set address= null
where address='pune';


update customer 
set address='pune'
where address is null;

DELIMITER //

CREATE PROCEDURE get_customer_info(IN customer_name VARCHAR(50))
BEGIN
    SELECT * FROM customer c
    inner join orders o
    on c.id = o.customer_id
    where c.name = customer_name;
END //

DELIMITER ;

drop procedure get_customer_info;
call get_customer_info('hardik');

Set sql_safe_updates=0;

DELIMITER //

CREATE TRIGGER update_last_updated
BEFORE INSERT ON Orders
FOR EACH ROW
BEGIN
    SET NEW.date = NOW();
END //

DELIMITER ;

insert into orders values (104,'2023-02-21',5,2500);

DELIMITER //
Create procedure insert_order(
in OID int,
in date datetime,
customer_id int,
amount decimal(10,2))
Begin 
	declare success int default 0;
    DECLARE insert_success INT DEFAULT 0;
    DECLARE balance_update_success INT DEFAULT 0;

	start transaction;
    
    insert into orders 
    value (OID,date,customer_id,amount);
	SELECT ROW_COUNT() INTO insert_success;

    
    if row_count()=1 then 
		set success=1;
    end if;
    
    if success =1 then
		if not exists(
			SELECT 1 from information_schema.columns
			where table_name = "customer" and column_name="balance")
			then 
			set @sql = 'Alter table customer add column balance int';
			prepare stmt from @sql;
			execute stmt ;
			DEALLOCATE PREPARE stmt;
        end if;
	end if;
    
    if success=1 then 
		Update customer c
		SET balance= c.salary - amount
		where c.id = customer_id and salary >= amount;
    END if;
    
        SELECT ROW_COUNT() INTO balance_update_success;
    if ( insert_success = 1 and balance_update_success=1) then 
		commit;
		select "transaction sucessful";
    else
		rollback;
        select "transaction fail";
	END if;
end;
 
// DELIMITER ;
drop procedure insert_order;

call insert_order(105,'2023-02-21',6,1000);

update customer c 
set balance = c.salary - orders.amount;
UPDATE customer c
JOIN (
    SELECT customer_id, SUM(amount) AS total_amount
    FROM orders
    GROUP BY customer_id
) AS order_totals ON c.id = order_totals.customer_id
SET c.balance = c.salary - order_totals.total_amount;

Create index customer_name on customer (name);

show tables;


SELECT TABLE_NAME, VIEW_DEFINITION
FROM information_schema.VIEWS
WHERE TABLE_SCHEMA = 'topper';

DESCRIBE customer;

CHECK TABLE customer;
SHOW STATUS;


SELECT 
    name,
    CASE 
        WHEN salary < 2000.00 THEN 'low'
        WHEN salary >= 2000.00 AND salary < 6000.00 THEN 'mid'
        ELSE 'high'
    END AS salary_status
FROM 
    customer;

 SELECT 
    name,
    IF(salary >= 5000, 'Above threshold', 'Below threshold') AS salary_status
FROM 
    customer;
select substring(name,1,3) as initial_names from Customer;

create procedure increSalary() 
select name , (salary+ (salary + 10)/100) as Salary_incre 
from customer;

call increSalary();

create procedure INCREMENT_SALARY()
select name,Salary * 1.10 as Hiked_salary
from customer ;

call INCREMENT_SALARY();

drop procedure increSalary;

