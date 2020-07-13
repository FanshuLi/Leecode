SELECT * FROM sys.`1174-delivery`;

-- 1. first date: earliest order (min)
-- 2. count(all customer first order) = total customers
-- 3. datediff = 0 
SELECT ROUND(SUM(IF(DATEDIFF(order_date,prefer_date)=0,1,0))/ COUNT(DISTINCT customer_id) *100,2) 
AS immediate_percentage
FROM sys.`1174-delivery`
WHERE (customer_id, order_date) IN (
				SELECT customer_id, MIN(order_date)
				FROM sys.`1174-delivery`
				GROUP BY customer_id);