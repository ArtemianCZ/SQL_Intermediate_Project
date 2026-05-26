
WITH days AS (
SELECT
	generate_series(DATE '2023-01-01', DATE '2023-03-31', INTERVAL '1 day')::date AS calend_date
	)
	
SELECT
	TO_CHAR(d.calend_date , 'YYYY-MM-DD') AS order_day,
	COALESCE(SUM(quantity * netprice * exchangerate),0) AS net_price

FROM
	days AS d
	LEFT JOIN sales AS s
	ON s.orderdate >= d.calend_date - INTERVAL '6 days'
	AND s.orderdate < d.calend_date + INTERVAL '1 day'
	
GROUP BY order_day
ORDER BY order_day;



WITH order_days AS (
	SELECT
		DATE_TRUNC('day',orderdate) AS calend_date,
		SUM(quantity * netprice * exchangerate) AS net_price

	FROM
		sales
	WHERE orderdate BETWEEN '2023-01-01' AND '2023-03-31'
	GROUP BY calend_date
	ORDER BY calend_date
	)
	
SELECT
	calend_date,
	SUM(net_price) OVER (ORDER BY calend_date ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) AS running_total

FROM order_days
	
	
	