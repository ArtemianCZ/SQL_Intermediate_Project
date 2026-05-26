-- cviceni
SELECT UPPER('Vojtech HLAVENKA');
SELECT LOWER('Vojtech HLAVENKA');
SELECT TRIM('   Vojtech HLAVENKA');
SELECT TRIM(BOTH '@ ' FROM '@@@   Vojtech Hlavenka');

-- cviceni vetsi
SELECT 
	CONCAT(countryname, ': ', description) AS unified_name
FROM store;

SELECT 
	TRIM(CONCAT(UPPER(description), ', Opened: ', TO_CHAR(opendate, 'Month DD, YYYY'))) AS unified_name
FROM store;

SELECT
	subcategorykey,
	productcode,
	ROW_NUMBER() OVER (PARTITION BY subcategorykey ORDER BY productcode),
	LPAD(ROW_NUMBER() OVER (PARTITION BY subcategorykey ORDER BY productcode)::text, 3, '0'),
	CONCAT(subcategorykey,LPAD(ROW_NUMBER() OVER (PARTITION BY subcategorykey ORDER BY productcode)::text, 3, '0'))::integer AS productcode
FROM product;

-- priklad
DROP VIEW IF EXISTS cohort_analysis;

CREATE VIEW cohort_analysis AS

WITH customer_revenue AS (
	SELECT 
		s.customerkey,
		s.orderdate,
		SUM(s.quantity * s.netprice * s.exchangerate) AS total_net_revenue,
		COUNT(s.orderkey) AS number_of_orders,
		c.countryfull,
		c.age,
		CONCAT(TRIM(c.givenname), ' ', TRIM(c.surname)) AS cleaned_name
	
	FROM sales AS s
	LEFT JOIN customer c ON c.customerkey = s.customerkey 
	
	GROUP BY
		s.customerkey,
		s.orderdate,
		c.countryfull,
		c.age,
		c.givenname,
		c.surname
		)
		
SELECT
	cr.*,
	MIN(cr.orderdate) OVER (PARTITION BY cr.customerkey) AS first_purchase_date,
	EXTRACT(YEAR FROM MIN(cr.orderdate) OVER (PARTITION BY cr.customerkey)) AS cohort_year
FROM customer_revenue AS cr