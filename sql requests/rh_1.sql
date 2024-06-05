SELECT CONCAT(employees.firstName," ",employees.lastName) AS full_name, CONCAT(offices.city, ", ", offices.country) AS bureau, MONTHNAME(paymentDate) as paymonth, YEAR(paymentDate) AS payyear, payments.paymentDate, payments.amount
FROM employees
JOIN customers ON employees.employeeNumber = customers.salesRepEmployeeNumber
JOIN payments ON customers.customerNumber = payments.customerNumber
JOIN offices ON offices.officeCode = employees.officeCode
ORDER BY payments.paymentDate;