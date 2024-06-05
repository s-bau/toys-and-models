/* Requête chiffres d'affaires */
SELECT c.country,
CASE
    WHEN DATE(p.paymentDate) >= DATE(DATE_SUB(NOW(), INTERVAL 2 MONTH))
	AND DATE(p.paymentDate) < DATE(DATE_SUB(NOW(), INTERVAL 1 MONTH))
	THEN "Previous month"
    WHEN DATE(p.paymentDate) >= DATE(DATE_SUB(NOW(), INTERVAL 1 MONTH))
    THEN "This month"
    END AS month,
CASE
    WHEN DATE(p.paymentDate) >= DATE(DATE_SUB(NOW(), INTERVAL 2 MONTH))
	AND DATE(p.paymentDate) < DATE(DATE_SUB(NOW(), INTERVAL 1 MONTH))
	THEN p.amount
    ELSE 0
    END AS previousMonth,
CASE
    WHEN DATE(p.paymentDate) >= DATE(DATE_SUB(NOW(), INTERVAL 1 MONTH))
    THEN p.amount
    ELSE 0
    END AS thisMonth,
CASE
    WHEN DATE(p.paymentDate) >= DATE(DATE_SUB(NOW(), INTERVAL 2 MONTH))
    THEN p.amount
    ELSE 0
    END AS lastTwoMonths
FROM customers AS c
INNER JOIN payments AS p ON p.customerNumber=c.customerNumber
WHERE DATE(p.paymentDate) >= DATE(DATE_SUB(NOW(), INTERVAL 2 MONTH))
ORDER BY c.country;



