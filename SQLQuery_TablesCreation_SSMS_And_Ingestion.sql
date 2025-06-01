-- Table des modes de livraison
CREATE TABLE ShipModes (
    ship_mode_id INT PRIMARY KEY IDENTITY(1,1),
    ship_mode VARCHAR(50) UNIQUE NOT NULL
);

-- Table des régions (clé primaire simplifiée avec region_id)
CREATE TABLE Regions (
    region_id INT PRIMARY KEY IDENTITY(1,1),
    region_name VARCHAR(50),
    country VARCHAR(50),
    state VARCHAR(50),
    city VARCHAR(50),
    postal_code INT
);

-- Table des clients
CREATE TABLE Customers (
    customer_id VARCHAR(50) PRIMARY KEY,
    customer_name VARCHAR(100),
    segment VARCHAR(50)
);

-- Table des produits
CREATE TABLE Products (
    product_uid INT PRIMARY KEY IDENTITY(1,1),
    product_id VARCHAR(50),
    product_name VARCHAR(255),
    category VARCHAR(50),
    sub_category VARCHAR(50)
);

-- Table des commandes
CREATE TABLE Orders (
    order_id VARCHAR(50) PRIMARY KEY,
    order_date DATE,
    ship_date DATE,
    customer_id VARCHAR(50),
    ship_mode_id INT,
    region_id INT,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id),
    FOREIGN KEY (ship_mode_id) REFERENCES ShipModes(ship_mode_id),
    FOREIGN KEY (region_id) REFERENCES Regions(region_id)
);

-- Détails de chaque commande
CREATE TABLE OrderDetails (
    row_id INT PRIMARY KEY,
    order_id VARCHAR(50),
    product_uid INT,
    sales FLOAT,
    quantity INT,
    discount FLOAT,
    profit FLOAT,
    FOREIGN KEY (order_id) REFERENCES Orders(order_id),
    FOREIGN KEY (product_uid) REFERENCES Products(product_uid)
);


CREATE TABLE test_superstore (
    row_id INT,
    order_id VARCHAR(50),
    order_date DATE,
    ship_date DATE,
    ship_mode VARCHAR(50),
    customer_id VARCHAR(50),
    customer_name VARCHAR(100),
    segment VARCHAR(50),
    country VARCHAR(50),
    city VARCHAR(50),
    state VARCHAR(50),
    postal_code INT,
    region VARCHAR(50),
    product_id VARCHAR(50),
    category VARCHAR(50),
    sub_category VARCHAR(50),
    product_name VARCHAR(255),
    sales FLOAT,
    quantity INT,
    discount FLOAT,
    profit FLOAT
);

-- Ajout de colonnes dans la table Orders
ALTER TABLE Orders ADD order_year INT;
ALTER TABLE Orders ADD order_month VARCHAR(20);
ALTER TABLE Orders ADD order_yy_mm VARCHAR(7);

ALTER TABLE test_superstore
ADD order_year INT,
    order_month INT,
    order_yy_mm VARCHAR(7);

BULK INSERT test_superstore
FROM 'C:\Users\nordi\Portfolio\superstore_dataset_clean.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    TABLOCK,
    CODEPAGE = '65001'  -- UTF-8
);

-- 1. Insert into ShipModes
INSERT INTO ShipModes (ship_mode)
SELECT DISTINCT ts.ship_mode
FROM test_superstore ts
WHERE ts.ship_mode IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM ShipModes sm WHERE sm.ship_mode = ts.ship_mode
);

-- 2. Insert into Customers
INSERT INTO Customers (customer_id, customer_name, segment)
SELECT DISTINCT ts.customer_id, ts.customer_name, ts.segment
FROM test_superstore ts
WHERE ts.customer_id IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM Customers c WHERE c.customer_id = ts.customer_id
);

-- 3. Insert into Products
INSERT INTO Products (product_id, product_name, category, sub_category)
SELECT DISTINCT ts.product_id, ts.product_name, ts.category, ts.sub_category
FROM test_superstore ts
WHERE ts.product_id IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM Products p WHERE p.product_id = ts.product_id
);

-- 4. Insert into Regions
INSERT INTO Regions (region_name, country, state, city, postal_code)
SELECT DISTINCT ts.region, ts.country, ts.state, ts.city, ts.postal_code
FROM test_superstore ts
WHERE ts.region IS NOT NULL
  AND ts.country IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM Regions r
    WHERE r.region_name = ts.region
      AND r.country = ts.country
      AND r.state = ts.state
      AND r.city = ts.city
      AND r.postal_code = ts.postal_code
);

-- 5. Insert into Orders
INSERT INTO Orders (
    order_id, order_date, ship_date, customer_id,
    ship_mode_id, region_id,
    order_year, order_month, order_yy_mm
)
SELECT DISTINCT
    ts.order_id,
    ts.order_date,
    ts.ship_date,
    ts.customer_id,
    sm.ship_mode_id,
    r.region_id,
    ts.order_year,
    ts.order_month,
    ts.order_yy_mm
FROM test_superstore ts
JOIN ShipModes sm ON ts.ship_mode = sm.ship_mode
JOIN Regions r 
    ON ts.region = r.region_name
   AND ts.country = r.country
   AND ts.state = r.state
   AND ts.city = r.city
   AND ts.postal_code = r.postal_code
WHERE NOT EXISTS (
    SELECT 1 FROM Orders o WHERE o.order_id = ts.order_id
);

-- 6. Insert into OrderDetails
INSERT INTO OrderDetails (row_id, order_id, product_uid, sales, quantity, discount, profit)
SELECT
    ts.row_id,
    ts.order_id,
    p.product_uid,
    ts.sales,
    ts.quantity,
    ts.discount,
    ts.profit
FROM test_superstore ts
JOIN Products p ON 
    ts.product_id = p.product_id AND
    ts.product_name = p.product_name AND
    ts.category = p.category AND
    ts.sub_category = p.sub_category;

