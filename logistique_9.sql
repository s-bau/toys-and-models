/*stock par categorie*/
SELECT p.productLine, SUM(p.buyPrice * p.quantityInStock) AS totalStockValue
FROM products p
GROUP BY p.productLine;