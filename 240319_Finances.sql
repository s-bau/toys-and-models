USE toys_and_models;

/* chiffres d'affaires des commandes des deux derniers mois par pays */
SELECT c.country,
SUM(CASE
    WHEN DATE(p.paymentDate) >= DATE(DATE_SUB(NOW(), INTERVAL 2 MONTH))
	AND DATE(p.paymentDate) < DATE(DATE_SUB(NOW(), INTERVAL 1 MONTH))
	THEN p.amount
    ELSE 0
    END) AS 2_months_ago,
SUM(CASE
    WHEN DATE(p.paymentDate) >= DATE(DATE_SUB(NOW(), INTERVAL 1 MONTH))
    THEN p.amount
    ELSE 0
    END) AS last_month
FROM customers AS c
INNER JOIN payments AS p ON p.customerNumber=c.customerNumber
WHERE DATE(p.paymentDate) >= DATE(DATE_SUB(NOW(), INTERVAL 2 MONTH))
GROUP BY c.country
ORDER BY c.country;

/* alternative to orders not yet paid: */
/* amounts ordered in last 2 months and order status */
SELECT od.orderNumber,
SUM(od.quantityOrdered * od.priceEach) AS amount,
o.orderDate,
o.status
FROM orderdetails AS od
INNER JOIN orders AS o ON o.orderNumber=od.orderNumber
WHERE DATE(o.orderDate) >= DATE(DATE_SUB(NOW(), INTERVAL 2 MONTH))
GROUP BY od.orderNumber
ORDER BY o.status, o.orderDate DESC;

/* Issues with orders within the last 6 months */
SELECT od.orderNumber,
SUM(od.quantityOrdered * od.priceEach) AS amount,
o.orderDate,
o.status,
o.comments
FROM orderdetails AS od
INNER JOIN orders AS o ON o.orderNumber=od.orderNumber
WHERE DATE(o.orderDate) >= DATE(DATE_SUB(NOW(), INTERVAL 6 MONTH))
AND NOT o.status LIKE "%Shipped%"
GROUP BY od.orderNumber
ORDER BY o.orderDate DESC;