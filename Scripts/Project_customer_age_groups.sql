
DROP VIEW IF EXISTS customer_age_category;
CREATE VIEW customer_age_category AS

SELECT
	customerkey,
	birthday,
	AGE(CURRENT_DATE, birthday) AS current_age,
	EXTRACT(MONTH FROM AGE(CURRENT_DATE, birthday)) + EXTRACT(YEAR FROM AGE(CURRENT_DATE, birthday)) * 12 AS age_in_month,
	CASE
		WHEN CURRENT_DATE - INTERVAL '25 years' <= birthday THEN 'Young'
		WHEN CURRENT_DATE - INTERVAL '50 years' <= birthday THEN 'Middle-Age'
		ELSE 'Elder'
	END AS age_category
FROM customer