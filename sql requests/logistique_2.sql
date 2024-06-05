/* 20/80 */
WITH total_sales AS (
    SELECT  SUM(p.amount) as total
    FROM payments p
    JOIN customers c ON p.customerNumber = c.customerNumber
    JOIN orders o ON c.customerNumber = o.customerNumber
    JOIN orderdetails od ON o.orderNumber = od.orderNumber
),
product_sales AS (
    SELECT od.productCode, pr.productName, SUM(p.amount) as product_total
    FROM payments AS p
    JOIN customers c ON p.customerNumber = c.customerNumber
    JOIN orders o ON c.customerNumber = o.customerNumber
    JOIN orderdetails od ON o.orderNumber = od.orderNumber
    JOIN products pr ON pr.productCode = od.productCode
    GROUP BY od.productCode, pr.productName
),
cumulative_sales AS (
    SELECT productCode, productName, product_total, SUM(product_total) OVER (ORDER BY product_total DESC) as cumulative_total
    FROM product_sales
)
SELECT cs.productCode, cs.productName, cs.product_total, cs.cumulative_total, ts.total
FROM cumulative_sales cs, total_sales ts
WHERE cs.cumulative_total <= ts.total * 0.8;