DROP TABLE line_item;
DROP TABLE customer_order;
DROP TABLE customer;
DROP TABLE item;
DROP TABLE Item_price_history;

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

CREATE TABLE Item_price_history(
history_id DECIMAL(10) NOT NULL,
item_id DECIMAL(10) NULL ,
old_price DECIMAL(10),
new_price DECIMAL(10),
changed_date DATE,
PRIMARY KEY (HISTORY_ID),
FOREIGN KEY (ITEM_ID) REFERENCES ITEM);

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

-- 8. Reusable stored procedure creation - Create a new customer

CREATE PROCEDURE ADD_CUSTOMER
	@cus_id_arg DECIMAL, 
	@first_name_arg VARCHAR(30),
	@last_name_arg VARCHAR(40) 
AS 
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
CREATE PROCEDURE ADD_CUSTOMER 
	@cus_id_arg DECIMAL, 
	@first_name_arg VARCHAR(30),
	@last_name_arg VARCHAR(40), 
	@cust_balance DECIMAL(6,2) 
AS 
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
DELETE FROM line_item 
WHERE order_id IN (SELECT order_id  
				   FROM customer_order 
				   JOIN customer ON customer_order.customer_ID = customer.customer_ID
				   WHERE customer.customer_ID = @cus_id_arg);
-- DELETE FROM CUSTOMER_ORDER
DELETE FROM customer_order 
WHERE customer_ID = @cus_id_arg;

-- DELETE CUSTOMER FROM CUSTOMER
DELETE FROM customer 
WHERE customer_ID = @cus_id_arg;				   

END;

EXEC DELETE_CUSTOMER 1;


SELECT * FROM CUSTOMER
SELECT * FROM CUSTOMER_ORDER
SELECT * FROM line_item

-- PART TWO TRIGGERS

-- 15. 
CREATE TRIGGER no_neg_cust_bal_trg
ON customer
AFTER INSERT,UPDATE
AS
BEGIN
DECLARE @CUSTOMER_TOTAL DECIMAL;
SET @CUSTOMER_TOTAL= (SELECT INSERTED.customer_total FROM INSERTED);
	IF @CUSTOMER_TOTAL < 0
		BEGIN
		ROLLBACK
		RAISERROR('Customer balance cannot be negative',14,1);
	END;
END;

-- 16.
INSERT INTO customer VALUES(111,'Jasim','Abdul',-10);

-- 17. 
SELECT customer_ID FROM customer WHERE customer_ID = 111;

-- 18.
CREATE TRIGGER no_Glass_last_name
ON customer
AFTER INSERT, UPDATE
AS
BEGIN
DECLARE @CUSTOMER_LAST VARCHAR(255);
SET @CUSTOMER_LAST = (SELECT INSERTED.customer_last FROM INSERTED);
	IF @CUSTOMER_LAST LIKE 'Glass'
		BEGIN
		ROLLBACK
		RAISERROR('Customer last name can not be Glass',14,1);
	END;
END;

-- 19.
INSERT INTO customer VALUES(112,'Jasim','Glass',10);

-- 20. the table is above in the table creation section. 

-- 21.
CREATE TRIGGER Update_Item_Price
ON ITEM
AFTER UPDATE AS
BEGIN
	IF UPDATE(PRICE)
	BEGIN
		INSERT INTO Item_price_history(item_id,old_price,new_price,changed_date)
		SELECT I.item_id, D.PRICE, I.PRICE, GETDATE()
		FROM INSERTED I
		LEFT JOIN DELETED D ON I.item_id = D.item_id
	END
END;

UPDATE item
SET price = 11
where description = 'Plate'

INSERT INTO ITEM VALUES(31,'Plate',11);
INSERT INTO item VALUES(32,'Spoon',5);

select * from ITEM;
select * from Item_Price_History;

DROP TRIGGER Update_Item_Price;
DROP TABLE ITEM