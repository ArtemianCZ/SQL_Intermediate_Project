WITH sales_data AS (
	SELECT 
		customerkey,
		SUM(quantity * netprice * exchangerate) AS net_revenue 
	FROM sales
	GROUP BY customerkey
	)
	
SELECT
	AVG(s.net_revenue) spending_customer_avg_net_revenue,
	AVG(COALESCE(s.net_revenue, 0)) all_customers_avg_net_revenue
FROM customer AS c
LEFT JOIN sales_data AS s ON c.customerkey = s.customerkey;

--NULLIF and COALESCE demonstration
 SELECT
 	storekey,
 	description,
 	COALESCE(NULLIF(description, 'Online store'),'0') AS description_clean
 
 FROM store;

-- Total Net Revenue for those with no sales

SELECT
	s.storekey,
	sa.quantity * sa.netprice * sa.exchangerate AS store_revenue,
	COALESCE (sa.quantity * sa.netprice * sa.exchangerate , 0) AS store_revenue_null
	
FROM store AS s
LEFT JOIN sales AS sa ON s.storekey = sa.storekey

WHERE sa.quantity * sa.netprice * sa.exchangerate IS NULL;

-- average revenue per store both with and without zeros
WITH store_revenue AS (	
	SELECT
		s.storekey,
		SUM(sa.quantity * sa.netprice * sa.exchangerate) AS store_revenue,
		SUM(COALESCE (sa.quantity * sa.netprice * sa.exchangerate , 0)) AS store_revenue_null
		
	FROM store AS s
	LEFT JOIN sales AS sa ON s.storekey = sa.storekey
	GROUP BY s.storekey 
	ORDER BY s.storekey
)

SELECT
	AVG(store_revenue) AS avg_revenue_with_null,
	AVG(store_revenue_null) AS avg_revenue_without_null
FROM store_revenue


