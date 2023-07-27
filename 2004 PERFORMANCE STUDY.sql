##what are the earliest and latest dates for orders
	##THIS DB HAS DATES STARTING FROM 2003/01/06 TO 2005/05/31

SELECT
    min(orderDate) as earliest,
    max(orderDate) as latest
FROM
    orders;

##How many order from 2003 to 2004
	##THERE WERE A TOTAL OF 112 ORDERS FROM 2003 TO 2004

SELECT
    count(ordernumber) as number_of_orders
FROM
    orders
WHERE
    orderDate BETWEEN "2003-01-06" and "2004-01-06";

##How much was profit during that year
	##TOTAL OF SALES WAS $3,366,963

SELECT
    round(sum(quantityordered*priceeach)) as profit
FROM
    orderdetails od
JOIN orders o ON od.orderNumber = o.orderNumber
WHERE
    o.orderDate BETWEEN "2003-01-06" and "2004-01-06";

##Top 10 product line
	##THE TOP 10 PRODUCT LINE ITEMS WERE
		##1992 Ferrari 360 Spider red
		##1937 Lincoln Berline
		##American Airlines: MD-11S
		##1941 Chevrolet Special Deluxe Cabriolet
		##1930 Buick Marquette Phaeton
		##1940s Ford truck
		##1969 Harley Davidson Ultimate Chopper
		##1957 Chevy Pickup
		##1964 Mercedes Tour Bus
		##1956 Porsche 356A Coupe

SELECT
    od.productCode,
    p.productname,
    sum(od.quantityordered) as amount_ordered
FROM    
    orderdetails od
JOIN
    products p ON od.productCode = p.productCode
GROUP BY
    1,2
ORDER BY
   sum(od.quantityordered) DESC
LIMIT
    10;

##Top 5 employees for year 2004
	##TOP 5 EMPLOYEES FOR 2004 WERE: 
		##Gerard Hernandez
		##George Vanauf
		##Pamela Castillo
		##Barry Jones
		##Peter Marsh

Select
	e.employeenumber,
    concat(e.firstname,' ',e.lastname) as full_name,
    sum(od.quantityordered*od.priceeach) as total_sales
FROM
	employees e
JOIN customers c on e.employeeNumber = c.salesrepemployeenumber
JOIN orders o on c.customerNumber = o.customernumber
JOIN orderdetails od on o.orderNumber = od.orderNumber
WHERE
	o.orderDate BETWEEN '2003-12-31' and '2005-01-01'
GROUP BY
	1,2
ORDER BY
	3 desc
LIMIT
	5;

##Top 5 sellers per product line
WITH top5 as
(
SELECT
	p.productcode as pc,
    p.productline as pl,
    sum(quantityordered*priceeach) as total_sales,
    DENSE_RANK() over (PARTITION BY p.productLine ORDER BY sum(quantityordered*priceeach) desc) as RNK
FROM
	products p
JOIN orderdetails od on p.productcode = od.productCode
JOIN orders o ON od.orderNumber = o.orderNumber
WHERE
	o.orderDate BETWEEN '2003-12-31' and '2005-01-01'
GROUP BY
	1,2
    )
SELECT
	pc,
    pl,
    total_sales,
    rnk
FROM
	top5
WHERE
	rnk <= 5
	

