
CREATE TABLE Delivery_service (
delivery_service_id DECIMAL(12) PRIMARY KEY,
name VARCHAR(64) NOT NULL
);

CREATE TABLE Package (
package_nr DECIMAL(12)   PRIMARY KEY,
description VARCHAR(255) NOT NULL,
date_delivered DATE      NOT NULL,
delivery_service_id DECIMAL(12) 
);

ALTER TABLE Package
ADD CONSTRAINT delivery_package_fk
FOREIGN KEY(delivery_service_id) 
REFERENCES Delivery_service (delivery_service_id);

INSERT INTO Delivery_service (delivery_service_id, name)
VALUES (11, 'United Package Delivery');
INSERT INTO Delivery_service (delivery_service_id, name)
VALUES (12, 'Federal Delivery');
INSERT INTO Delivery_service (delivery_service_id, name)
VALUES (13, 'Dynamic Duo Delivery');


INSERT INTO Package (package_nr, description, date_delivered, delivery_service_id)
VALUES (14, 'Perfect diamonds', '29-Apr-2012', 11);

INSERT INTO Package (package_nr, description, date_delivered, delivery_service_id)
VALUES (15, 'Care package', '14-Jun-2012', 12);

INSERT INTO Package (package_nr, description, date_delivered, delivery_service_id)
VALUES (16, 'French wine', '19-Jul-2012', NULL);

-- a Package that references a non‐existent delivery service.-- 

INSERT INTO Package (package_nr, description, date_delivered, delivery_service_id)
VALUES (17, 'French wine', '19-Jul-2012', 10);

-- 11 - With a sngle SQL Query. --

SELECT Package.description, Package.date_delivered, Delivery_service.name 
FROM Delivery_service
JOIN Package ON Delivery_service.delivery_service_id = Package.delivery_service_id;

-- 14 - With a single SQL Query. -- 

SELECT Delivery_service.name, Package.description, Package.date_delivered
FROM Package
LEFT JOIN Delivery_service ON Package.delivery_service_id = Delivery_service.delivery_service_id;


-- 16 - With a single SQL Query. --

SELECT Package.description, Package.date_delivered, Delivery_service.name
FROM Delivery_service
RIGHT JOIN Package ON Delivery_service.delivery_service_id = Package.delivery_service_id
ORDER BY Delivery_service.name ASC; 

-- 18 - With a single SQL Query. --

SELECT Package.description, Package.date_delivered, Delivery_service.name
FROM Delivery_service
FULL JOIN Package ON Delivery_service.delivery_service_id = Package.delivery_service_id
ORDER BY Package.description DESC;