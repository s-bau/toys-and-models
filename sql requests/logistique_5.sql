/*Calcul de la marge et du coefficient de marge*/
WITH sales AS (
  SELECT od.productCode, SUM(od.quantityOrdered * p.buyPrice) AS cost, SUM(od.quantityOrdered * p.MSRP) AS revenue
  FROM orderdetails od
  JOIN products p ON od.productCode = p.productCode
  GROUP BY od.productCode
)
SELECT s.productCode, (s.revenue - s.cost) AS margin, (s.revenue / s.cost) AS marginCoefficient
FROM sales s;