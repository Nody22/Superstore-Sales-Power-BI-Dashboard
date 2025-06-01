-- Total des ventes par catégorie
SELECT 
    p.category,
    SUM(od.sales) AS total_sales
FROM OrderDetails od
JOIN Products p ON od.product_uid = p.product_uid
GROUP BY p.category
ORDER BY total_sales DESC;

 -- Profit total par segment client
 SELECT 
    c.segment,
    SUM(od.profit) AS total_profit
FROM Orders o
JOIN Customers c ON o.customer_id = c.customer_id
JOIN OrderDetails od ON o.order_id = od.order_id
GROUP BY c.segment
ORDER BY total_profit DESC;

-- Top 10 des villes avec le plus de ventes
SELECT 
    r.city,
    SUM(od.sales) AS total_sales
FROM Orders o
JOIN Regions r ON o.region_id = r.region_id
JOIN OrderDetails od ON o.order_id = od.order_id
GROUP BY r.city
ORDER BY total_sales DESC
OFFSET 0 ROWS FETCH NEXT 10 ROWS ONLY;

-- Évolution des ventes mensuelles (année/mois)
SELECT 
    order_yy_mm,
    SUM(sales) AS total_sales
FROM Orders o
JOIN OrderDetails od ON o.order_id = od.order_id
GROUP BY order_yy_mm
ORDER BY order_yy_mm;

-- Produits les plus vendus en volume
SELECT
p.product_name,
SUM(od.quantity) AS total_quantity
FROM OrderDetails od
JOIN Products p ON od.product_uid = p.product_uid
GROUP BY p.product_name
ORDER BY total_quantity DESC
OFFSET 0 ROWS FETCH NEXT 10 ROWS ONLY

-- Produits avec le plus de pertes (profits négatifs)
SELECT 
    p.product_name,
    SUM(od.profit) AS total_profit
FROM OrderDetails od
JOIN Products p ON od.product_uid = p.product_uid
GROUP BY p.product_name
HAVING SUM(od.profit) < 0
ORDER BY total_profit ASC;