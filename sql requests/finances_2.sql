/* Requête commandes */
WITH orders_and_payments AS (
	SELECT customers.customerNumber AS customerNumber,
	customers.customerName,
	customers.country,
       	COALESCE(SUM(orderdetails.quantityOrdered * orderdetails.priceEach), 0) AS amount_ordered,
       	COALESCE(amount, 0) AS amount_paid
	FROM customers
	LEFT JOIN orders ON orders.customerNumber = customers.customerNumber
	INNER JOIN orderdetails ON orders.orderNumber = orderdetails.orderNumber
	LEFT JOIN (
    	SELECT customerNumber, SUM(amount) AS amount
    	FROM payments
    	GROUP BY customerNumber
	) AS p ON p.customerNumber = customers.customerNumber
	WHERE orders.status NOT LIKE "%Cancelled%"
	GROUP BY customers.customerNumber
	ORDER BY customers.customerNumber
)
SELECT customerNumber,
customerName,
country,
amount_ordered,
amount_paid,
CASE
	WHEN (amount_ordered - amount_paid) < 0 THEN 0.00
	ELSE (amount_ordered - amount_paid)
	END AS unpaid
FROM orders_and_payments
/* WHERE (amount_ordered - amount_paid) > 0 */
ORDER BY unpaid DESC;


