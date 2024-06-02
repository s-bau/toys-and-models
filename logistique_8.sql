/*Calcul du chiffre d'affaires par année*/
SELECT DATE_FORMAT(o.orderDate, '%Y') AS orderYear, SUM(p.amount) AS totalSales
FROM payments p
JOIN customers c ON p.customerNumber = c.customerNumber
JOIN orders o ON c.customerNumber = o.customerNumber
GROUP BY orderYear;