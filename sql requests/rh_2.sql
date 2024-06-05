WITH top2 AS
(SELECT full_name, city, paymonth, payyear, amount, RANK () OVER (PARTITION BY paymonth, payyear ORDER BY amount DESC) AS ranking, paymentDate, client, client_city
FROM (SELECT CONCAT(employees.firstName, " ", employees.lastName) AS full_name, MONTHNAME(payments.paymentDate) as paymonth, YEAR(payments.paymentDate) AS payyear, payments.amount, offices.city, payments.paymentDate, customers.customerName AS client, CONCAT(customers.city, ", ", customers.country) AS client_city
FROM employees
JOIN customers ON employees.employeeNumber = customers.salesRepEmployeeNumber
JOIN payments ON customers.customerNumber = payments.customerNumber
JOIN offices ON offices.officeCode = employees.officeCode) AS sales
GROUP BY full_name, paymonth, payyear, amount, city, paymentDate, client, client_city)
SELECT * FROM top2
WHERE ranking < 3
ORDER BY paymentDate DESC;