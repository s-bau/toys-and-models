/*Calcul de la valeur du stock*/
SELECT p.productCode, p.productName, p.buyPrice, p.quantityInStock, (p.buyPrice * p.quantityInStock) AS stockValue
FROM products p;