(SELECT p.productLine AS Category, date_format(orderDate,"%M %Y") as Date, 
SUM(od.quantityOrdered) AS Subtotal, YEAR(orderDate) AS Year , MONTHNAME(orderDate) AS Month,
	(SELECT SUM(od.quantityOrdered) FROM products as p
		JOIN orderdetails as od ON od.productCode= p.productCode
		JOIN orders as o ON o.orderNumber = od.orderNumber
                WHERE Month = MONTHNAME(orderDate)
                AND YEAR(orderDate)= Year-1
                AND p.productLine = Category) AS LastMonth,
	((SUM(od.quantityOrdered)- (SELECT SUM(od.quantityOrdered) FROM products as p
		JOIN orderdetails as od ON od.productCode= p.productCode
		JOIN orders as o ON o.orderNumber = od.orderNumber
                WHERE Month = MONTHNAME(orderDate)
                AND YEAR(orderDate)= Year-1
                AND p.productLine = Category))/ (SELECT SUM(od.quantityOrdered) FROM products as p
		JOIN orderdetails as od ON od.productCode= p.productCode
		JOIN orders as o ON o.orderNumber = od.orderNumber
                WHERE Month = MONTHNAME(orderDate)
                AND YEAR(orderDate)= Year-1
                AND p.productLine = Category))  *100 AS Evolution_Rate, MONTH(orderDate) AS Month_Nb
   FROM products as p
    JOIN orderdetails as od ON od.productCode= p.productCode
    JOIN orders as o ON o.orderNumber = od.orderNumber
    GROUP BY 1, 2, 4, 5, 8
    ORDER BY p.productLine)
  
UNION

    (SELECT 'total', date_format(orderDate,"%M %Y") as Date, 
SUM(od.quantityOrdered) AS Subtotal, YEAR(orderDate) AS Year , MONTHNAME(orderDate) AS Month,(
	 SELECT SUM(od.quantityOrdered) FROM products as p
		JOIN orderdetails as od ON od.productCode= p.productCode
		JOIN orders as o ON o.orderNumber = od.orderNumber
                WHERE Month = MONTHNAME(orderDate)
                AND YEAR(orderDate)= Year-1) AS LastMonth,
	 ((SUM(od.quantityOrdered)- (SELECT SUM(od.quantityOrdered) FROM products as p
		JOIN orderdetails as od ON od.productCode= p.productCode
		JOIN orders as o ON o.orderNumber = od.orderNumber
                WHERE Month = MONTHNAME(orderDate)
                AND YEAR(orderDate)= Year-1))/ (SELECT SUM(od.quantityOrdered) FROM products as p
		JOIN orderdetails as od ON od.productCode= p.productCode
		JOIN orders as o ON o.orderNumber = od.orderNumber
                WHERE Month = MONTHNAME(orderDate)
                AND YEAR(orderDate)= Year-1))  *100 AS Evolution_Rate,
                 MONTH(orderDate) AS Month_Nb
	FROM products as p
    JOIN orderdetails as od ON od.productCode= p.productCode
    JOIN orders as o ON o.orderNumber = od.orderNumber
    GROUP BY 2, 4, 5, 8
	ORDER BY FIELD (Month,"January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"));
