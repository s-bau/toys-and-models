/* Requête annulations */
SELECT orderdetails.orderNumber,
customers.customerNumber,
customers.customerName,
customers.country,
orders.orderDate,
SUM(orderdetails.quantityOrdered * orderdetails.priceEach) AS orderedAmount,
orders.status
FROM orderdetails
JOIN orders ON orders.orderNumber = orderdetails.orderNumber
JOIN customers ON customers.customerNumber = orders.customerNumber
WHERE orders.status LIKE "Cancelled"
GROUP BY orderdetails.orderNumber;
