
WITH monthly_revenues AS (
	SELECT
		TO_CHAR(DATE_TRUNC('MONTH', orderdate),'YYYY-MM') AS order_month,
		SUM(total_net_revenue) AS monthly_revenue,
		COUNT(DISTINCT customerkey) AS customers,
		SUM(total_net_revenue) / COUNT(DISTINCT customerkey) AS avg_customer_revenue
	
	FROM cohort_analysis
	
	GROUP BY order_month
	ORDER BY order_month
	)
	
SELECT 
	*,
	AVG(monthly_revenue) OVER (ORDER BY order_month ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) AS rolling_avg_monthly_revenue,
	AVG(customers) OVER (ORDER BY order_month ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) AS rolling_avg_customers,
	AVG(avg_customer_revenue) OVER (ORDER BY order_month ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) AS rolling_avg_customer_revenue

FROM monthly_revenues
