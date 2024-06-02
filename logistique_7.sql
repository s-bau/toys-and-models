/*Jours de stock*/
WITH yearly_sales AS (
    SELECT od.productCode, SUM(od.quantityOrdered) as units_sold
    FROM orderdetails od
    JOIN orders o ON od.orderNumber = o.orderNumber
    WHERE YEAR(o.orderDate) = 2023
    GROUP BY od.productCode),
  current_stock AS (  
    SELECT productCode, quantityInStock
    FROM products)
  SELECT cs.productCode, cs.quantityInStock, ys.units_sold, (cs.quantityInStock / ys.units_sold) * 365 as days_of_stock
  FROM current_stock cs
  JOIN yearly_sales ys ON cs.productCode = ys.productCode;