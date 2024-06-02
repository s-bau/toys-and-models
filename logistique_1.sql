/* 5 meilleures ventes et stock */
SELECT od.productCode, p.productName AS productName, SUM(quantityOrdered) AS totalSale, quantityInStock
FROM orderdetails AS od
JOIN products AS p ON p.productCode = od.productCode
GROUP BY od.productCode
ORDER BY totalSale DESC
LIMIT 5;