
DROP VIEW cohort_analysis;
CREATE OR REPLACE VIEW cohort_analysis AS
	
	WITH customer_revenue AS (
         SELECT s.customerkey,
            s.orderdate,
            sum(s.quantity::double precision * s.netprice * s.exchangerate) AS total_net_revenue,
            count(s.orderkey) AS number_of_orders,
            MAX(c.countryfull) AS countryfull,
            MAX(c.age) AS age,
            MAX(concat(TRIM(BOTH FROM c.givenname), ' ', TRIM(BOTH FROM c.surname))) AS cleaned_name
           FROM sales s
             LEFT JOIN customer c ON c.customerkey = s.customerkey
          GROUP BY s.customerkey, s.orderdate
        )
 SELECT customerkey,
    orderdate,
    total_net_revenue,
    number_of_orders,
    countryfull,
    age,
    cleaned_name,
    min(orderdate) OVER (PARTITION BY customerkey) AS first_purchase_date,
    EXTRACT(year FROM min(orderdate) OVER (PARTITION BY customerkey)) AS cohort_year
   FROM customer_revenue cr;