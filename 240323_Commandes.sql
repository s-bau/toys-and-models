USE toys_and_models;

/* what each customer ordered and paid */
SELECT c.customerNumber,
       COALESCE(SUM(od.quantityOrdered * od.priceEach), 0) AS amount_ordered,
       COALESCE(amount, 0) AS amount_paid
FROM customers AS c
LEFT JOIN orders AS o ON o.customerNumber = c.customerNumber
INNER JOIN orderdetails AS od ON o.orderNumber = od.orderNumber
LEFT JOIN (
    SELECT customerNumber, SUM(amount) AS amount
    FROM payments
    GROUP BY customerNumber
) AS p ON p.customerNumber = c.customerNumber
GROUP BY c.customerNumber
ORDER BY c.customerNumber;

/* only values where payments and orders don't match up */
WITH orders_and_payments AS (
    SELECT c.customerNumber,
           COALESCE(SUM(od.quantityOrdered * od.priceEach), 0) AS amount_ordered,
           COALESCE(amount, 0) AS amount_paid
    FROM customers AS c
    LEFT JOIN orders AS o ON o.customerNumber = c.customerNumber
    INNER JOIN orderdetails AS od ON o.orderNumber = od.orderNumber
    LEFT JOIN (
        SELECT customerNumber, SUM(amount) AS amount
        FROM payments
        GROUP BY customerNumber
    ) AS p ON p.customerNumber = c.customerNumber
    GROUP BY c.customerNumber
    ORDER BY c.customerNumber
)
SELECT *
FROM orders_and_payments
WHERE (amount_ordered - amount_paid) <> 0;

/* All order details of every customer where payments don't match order amounts */
WITH orders_and_payments AS (
    SELECT c.customerNumber,
           COALESCE(SUM(od.quantityOrdered * od.priceEach), 0) AS amount_ordered,
           COALESCE(amount, 0) AS amount_paid
    FROM customers AS c
    LEFT JOIN orders AS o ON o.customerNumber = c.customerNumber
    INNER JOIN orderdetails AS od ON o.orderNumber = od.orderNumber
    LEFT JOIN (
        SELECT customerNumber, SUM(amount) AS amount
        FROM payments
        GROUP BY customerNumber
    ) AS p ON p.customerNumber = c.customerNumber
    GROUP BY c.customerNumber
    ORDER BY c.customerNumber
)
SELECT *
FROM orders
WHERE customerNumber IN (
SELECT customerNumber
FROM orders_and_payments
WHERE (amount_ordered - amount_paid) <> 0
)
ORDER BY customerNumber, orderDate;

/* Only details where not shipped and customer where payments don't match order amounts */
WITH orders_and_payments AS (
    SELECT c.customerNumber,
           COALESCE(SUM(od.quantityOrdered * od.priceEach), 0) AS amount_ordered,
           COALESCE(amount, 0) AS amount_paid
    FROM customers AS c
    LEFT JOIN orders AS o ON o.customerNumber = c.customerNumber
    INNER JOIN orderdetails AS od ON o.orderNumber = od.orderNumber
    LEFT JOIN (
        SELECT customerNumber, SUM(amount) AS amount
        FROM payments
        GROUP BY customerNumber
    ) AS p ON p.customerNumber = c.customerNumber
    GROUP BY c.customerNumber
    ORDER BY c.customerNumber
)
SELECT orderNumber,
orderDate,
shippedDate,
status,
comments,
customerNumber
FROM orders
WHERE customerNumber IN (
SELECT customerNumber
FROM orders_and_payments
WHERE (amount_ordered - amount_paid) <> 0
)
AND status NOT LIKE "%Shipped%"
ORDER BY orderDate DESC;