USE toys_and_models;

/* outstanding balances excluding cancellations from ordered amounts */
/* excluding negative differences */
WITH orders_and_payments AS (
    SELECT customers.customerNumber AS customerNumber,
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
amount_ordered,
amount_paid,
(amount_ordered - amount_paid) AS difference
FROM orders_and_payments
WHERE (amount_ordered - amount_paid) > 0
ORDER BY customerNumber;