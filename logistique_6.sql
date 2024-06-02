/*Calcul du CA n-1*/
SELECT DATE_FORMAT(o.orderDate, '%Y') AS orderYear, SUM(p.amount) AS totalSales
FROM payments p
JOIN customers c ON p.customerNumber = c.customerNumber
JOIN orders o ON c.customerNumber = o.customerNumber
WHERE YEAR(o.orderDate) = YEAR(CURRENT_DATE) - 1
GROUP BY orderYear;