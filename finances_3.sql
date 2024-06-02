/* Requête marges */
SELECT
products.productName,
AVG(products.buyPrice) AS averageBuyPrice,
SUM(orderdetails.quantityOrdered) AS totalQuantityOrdered,
AVG(orderdetails.priceEach) AS averagePriceEach,
AVG(orderdetails.priceEach) - AVG(products.buyPrice) AS averageMargin,
(AVG(orderdetails.priceEach) - AVG(products.buyPrice)) / AVG(products.buyPrice) * 100 AS averageMarginPerc
FROM products
JOIN orderdetails ON products.productCode = orderdetails.productCode
GROUP BY products.productName
ORDER BY totalQuantityOrdered DESC;

