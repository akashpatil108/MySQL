-- Create the database
CREATE DATABASE IF NOT EXISTS Arihant_agro;
USE Arihant_agro;

-- Create customers table
CREATE TABLE IF NOT EXISTS customers (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_name VARCHAR(255) NOT NULL,
    contact VARCHAR(20),
    address VARCHAR(255)
);

-- Create inventory table
CREATE TABLE IF NOT EXISTS inventory (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    product_name VARCHAR(255) NOT NULL,
    quantity INT NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    unit VARCHAR(20) NOT NULL
);

-- Create sale table
CREATE TABLE IF NOT EXISTS sale (
    sale_id INT AUTO_INCREMENT PRIMARY KEY,
    sale_date DATE NOT NULL,
    product_id INT,
    quantity INT NOT NULL,
    customer_id INT,
    GST ENUM('With GST', 'Without GST') NOT NULL,
    unit VARCHAR(20) NOT NULL,
    FOREIGN KEY (product_id) REFERENCES inventory(product_id),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);
SELECT * FROM arihant_agro.sale;
-- Create purchase table
CREATE TABLE IF NOT EXISTS purchase (
    purchase_id INT AUTO_INCREMENT PRIMARY KEY,
    purchase_date DATE NOT NULL,
    invoice_number VARCHAR(50) NOT NULL,
    product_id INT,
    product varchar(50) not null,
    quantity INT NOT NULL,
    unit VARCHAR(20) NOT NULL,
    customer_id INT,
    customer_name VARCHAR(255),
    FOREIGN KEY (product_id) REFERENCES inventory(product_id),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);
Select * from purchase;

-- Create payment table
CREATE TABLE IF NOT EXISTS payment (
    payment_id INT AUTO_INCREMENT PRIMARY KEY,
    invoice_number VARCHAR(50),
    payment_date DATE NOT NULL,
    amount DECIMAL(10, 2) NOT NULL,
    payment_method VARCHAR(50),
    sale_id INT,
    purchase_id INT,
    FOREIGN KEY (sale_id) REFERENCES sale(sale_id),
    FOREIGN KEY (purchase_id) REFERENCES purchase(purchase_id)
);
select * from payment;
-- Add columns: total_price, product_name, customer_name, challan_number
ALTER TABLE sale
ADD COLUMN total_price DECIMAL(10, 2) NOT NULL,
ADD COLUMN product_name VARCHAR(255) NOT NULL,
ADD COLUMN customer_name VARCHAR(255),
ADD COLUMN challan_number VARCHAR(50);

-- Drop foreign key constraints referencing product_id and customer_id
ALTER TABLE sale
DROP FOREIGN KEY sale_ibfk_1, 
DROP FOREIGN KEY sale_ibfk_2;

-- Drop columns: product_id, customer_id, unit
ALTER TABLE sale
DROP COLUMN product_id,
DROP COLUMN customer_id,
DROP COLUMN unit;

-- Change the data type of quantity to VARCHAR(100)
ALTER TABLE sale
MODIFY COLUMN quantity VARCHAR(100) NOT NULL;


-- Drop foreign key constraints referencing product_id and customer_id
ALTER TABLE purchase
DROP FOREIGN KEY purchase_ibfk_1, 
DROP FOREIGN KEY purchase_ibfk_2;

-- Drop columns: product_id, customer_id
ALTER TABLE purchase
DROP COLUMN product_id,
DROP COLUMN customer_id;

-- Add column: total_price
ALTER TABLE purchase
ADD COLUMN total_price DECIMAL(10, 2) NOT NULL;

-- Change the data type of quantity to VARCHAR(100)
ALTER TABLE purchase
MODIFY COLUMN quantity VARCHAR(100) NOT NULL;

Alter table purchase
drop column unit;

-- Add columns: note, customer_name, payment_direction
ALTER TABLE payment
ADD COLUMN note TEXT,
ADD COLUMN customer_name VARCHAR(255),
ADD COLUMN payment_direction ENUM('Debited', 'Credited');

-- Drop foreign key constraints referencing product_id and customer_id
-- ALTER TABLE payment
-- DROP FOREIGN KEY fk_sale_id,
-- DROP FOREIGN KEY fk_purchase_id;

alter table payment
drop column sale_id,
drop column purchase_id;




-- Remove "NOT NULL" constraint from columns in the inventory table
ALTER TABLE inventory
MODIFY COLUMN quantity INT,
MODIFY COLUMN price DECIMAL(10, 2),
MODIFY COLUMN unit VARCHAR(20);

-- Add "NOT NULL" constraint to the customer_name column in the sale table
ALTER TABLE sale
MODIFY COLUMN customer_name VARCHAR(255) NOT NULL;

-- Remove "NOT NULL" constraint from columns in the purchase table
ALTER TABLE purchase
MODIFY COLUMN invoice_number VARCHAR(50),
MODIFY COLUMN quantity INT;

-- Add "NOT NULL" constraint to the customer_name column in the purchase table
ALTER TABLE purchase
MODIFY COLUMN customer_name VARCHAR(255) NOT NULL;

-- Add "NOT NULL" constraint to the customer_name and payment_direction columns in the payment table
ALTER TABLE payment
MODIFY COLUMN customer_name VARCHAR(255) NOT NULL,
MODIFY COLUMN payment_direction ENUM('Debited', 'Credited') NOT NULL;

SELECT s.sale_date, c.customer_name,
       s.GST,  s.total_price,
       p.purchase_id, p.purchase_date, p.total_price, p.invoice_number,
       pay.payment_id, pay.payment_date, pay.amount
FROM customers c
RIGHT JOIN sale s ON c.customer_name = s.customer_name
RIGHT JOIN purchase p ON c.customer_name = p.customer_name
RIGHT JOIN payment pay ON c.customer_name = pay.customer_name
WHERE c.customer_name = 'akash ';

alter table purchase
add column GST ENUM('With GST', 'Without GST') NOT NULL;


select 
		s.sale_date as 'date' ,s.total_price as debit,
        s.GST as Particulars, s.challan_number as 'vch.no'
From  sale s
Where s.customer_name = 'akash ';

select 
		p.purchase_date as 'date' ,p.total_price as credit,
        p.GST as Particulars, p.invoice_number as 'vch.no'
From purchase p
Where p.customer_name = 'akash ';

SELECT pay.payment_date as "date",pay.amount as credit,
		pay.payment_method as Particulars, pay.invoice_number as 'vch.no'
FROM payment pay
WHERE pay.customer_name = "akash ";
		