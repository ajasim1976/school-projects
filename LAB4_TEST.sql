DROP TABLE line_item;
DROP TABLE customer_order;
DROP TABLE customer;
DROP TABLE item;

CREATE TABLE customer(
customer_ID DECIMAL(10) NOT NULL,
customer_first VARCHAR(30),
customer_last VARCHAR(40),
customer_total DECIMAL(12, 2),
PRIMARY KEY (customer_ID));
INSERT INTO customer VALUES(1,'John','Smith',0);
INSERT INTO customer VALUES(2,'Mary','Berman',0);
INSERT INTO customer VALUES(3,'Elizabeth','Johnson',0);
INSERT INTO customer VALUES(4,'Peter','Quigley',0);
INSERT INTO customer VALUES(5,'Stanton','Hurley',0);
INSERT INTO customer VALUES(6,'Yvette','Presley',0);
INSERT INTO customer VALUES(7,'Hilary','Marsh',0);

CREATE TABLE ITEM(
item_id DECIMAL(10) NOT NULL,
description VARCHAR(30),
price DECIMAL(10),
PRIMARY KEY (item_id));
INSERT INTO item VALUES(1,'Plate',10);
INSERT INTO item VALUES(2,'Bowl',11);
INSERT INTO item VALUES(3,'Knife',5);
INSERT INTO item VALUES(4,'Fork',5);
INSERT INTO item VALUES(5,'Spoon',5);
INSERT INTO item VALUES(6,'Cup',12);

CREATE TABLE customer_order (
order_id DECIMAL(10) NOT NULL,
customer_id DECIMAL(10) NOT NULL,
order_total DECIMAL(12,2),
order_date DATE,
PRIMARY KEY (ORDER_ID),
FOREIGN KEY (CUSTOMER_ID) REFERENCES customer);
INSERT INTO customer_order VALUES(1,1,506,CAST('18-DEC-2005' AS DATE));
INSERT INTO customer_order VALUES(2,1,1000,CAST('17-DEC-2005' AS DATE));
INSERT INTO customer_order VALUES(3,3,15,CAST('19-DEC-2005' AS DATE));
INSERT INTO customer_order VALUES(4,3,15,CAST('20-DEC-2005' AS DATE));
INSERT INTO customer_order VALUES(5,2,1584,CAST('18-DEC-2005' AS DATE));
INSERT INTO customer_order VALUES(6,4,100,CAST('17-DEC-2005' AS DATE));
INSERT INTO customer_order VALUES(7,5,40,CAST('18-DEC-2005' AS DATE));
INSERT INTO customer_order VALUES(8,1,10,CAST('19-DEC-2005' AS DATE));


CREATE TABLE line_item(
order_id DECIMAL(10) NOT NULL,
item_id DECIMAL(10) NOT NULL,
item_quantity DECIMAL(10) NOT NULL,
line_price DECIMAL(12,2),
PRIMARY KEY (ORDER_ID, ITEM_ID),
FOREIGN KEY (ORDER_ID) REFERENCES customer_order,
FOREIGN KEY (ITEM_ID) REFERENCES item);
INSERT INTO line_item VALUES(1,1,10,100);
INSERT INTO line_item VALUES(1,5,2,10);
INSERT INTO line_item VALUES(1,2,36,396);
INSERT INTO line_item VALUES(2,1,95,950);
INSERT INTO line_item VALUES(2,3,10,50);
INSERT INTO line_item VALUES(3,4,3,15);
INSERT INTO line_item VALUES(4,4,3,15);
INSERT INTO line_item VALUES(5,6,132,1584);
INSERT INTO line_item VALUES(6,1,10,100);
INSERT INTO line_item VALUES(7,5,5,25);
INSERT INTO line_item VALUES(7,4,3,15);
INSERT INTO line_item VALUES(8,5,2,10);
COMMIT;

-- 2. Create Store procedure 
CREATE PROCEDURE ADD_CUSTOMER_HARRY
AS
BEGIN
	INSERT INTO CUSTOMER (CUSTOMER_ID,CUSTOMER_FIRST,CUSTOMER_LAST,CUSTOMER_TOTAL)
	VALUES(8, 'Harry', 'Joker', 0);
END;

-- 5. Stored procedure execution
EXECUTE ADD_CUSTOMER_HARRY;

select * from customer

-- 8. Reusable stored procedure creation

CREATE PROCEDURE ADD_CUSTOMER -- Create a new customer
	@cus_id_arg DECIMAL, -- The new customer's ID.
	@first_name_arg VARCHAR(30), -- The new customer’s first name.
	@last_name_arg VARCHAR(40) -- The new customer's last name.
AS -- This "AS" is required by the syntax of stored procedures.
BEGIN
-- Insert the new customer with a 0 balance.
INSERT INTO CUSTOMER
(CUSTOMER_ID,CUSTOMER_FIRST,CUSTOMER_LAST,CUSTOMER_TOTAL)
VALUES(@cus_id_arg,@first_name_arg,@last_name_arg,0);
END;

-- 9. Reusable stored procedure execution

EXECUTE ADD_CUSTOMER 9,'Mary','Smith'

-- 10. Stored procedure execution verification

SELECT * FROM customer

-- 11. Fourth argument stored procedure creation
CREATE PROCEDURE ADD_CUSTOMER -- Create a new customer
	@cus_id_arg DECIMAL, -- The new customer's ID.
	@first_name_arg VARCHAR(30), -- The new customer’s first name.
	@last_name_arg VARCHAR(40), -- The new customer's last name.
	@cust_balance DECIMAL(6,2) -- The new customer's balance
AS -- This "AS" is required by the syntax of stored procedures.
BEGIN
-- Insert the new customer with a 0 balance.
INSERT INTO CUSTOMER
(CUSTOMER_ID,CUSTOMER_FIRST,CUSTOMER_LAST,CUSTOMER_TOTAL)
VALUES(@cus_id_arg,@first_name_arg,@last_name_arg,@cust_balance);
END;

-- 12. Fourth argument stored procedure execution

EXEC ADD_CUSTOMER 10,'Gabriela','Jury',10.99

-- 13. Stored procedure execution verification

SELECT * FROM customer

-- 14. Deletion stored procedure creation and execution

CREATE PROCEDURE DELETE_CUSTOMER -- Delete orders which placed by a customer
    @cus_id_arg DECIMAL -- customer's ID.
AS 
BEGIN
DELETE FROM customer -- Delete a customer 
	WHERE customer_ID = @cus_id_arg;

DELETE FROM line_item
	WHERE order_id IN (SELECT order_id
					   FROM customer_order
					   WHERE customer_id = @cus_id_arg);

END;

-- Execute Store procedure
EXEC DELETE_CUSTOMER 1;

SELECT * FROM customer
SELECT * FROM line_item
SELECT * FROM customer_order

-- DROP PROC
DROP PROCEDURE DELETE_CUSTOMER; 
DROP PROCEDURE ADD_CUSTOMER;
DROP PROCEDURE ADD_CUSTOMER_HARRY;
