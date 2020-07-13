
-- 1211.Queries Quality and Percentage

SELECT * FROM sys.`1211-queries`;

-- We define query quality as: The average of the ratio between query rating and its position.

-- We also define poor query percentage as: The percentage of all queries with rating less than 3.

-- Write an SQL query to find each query_name, the quality and poor_query_percentage.

-- Both quality and poor_query_percentage should be rounded to 2 decimal places.

SELECT a.query_name,quality, round(rating1/ tt_rat*100,2) as poor_query_percentage FROM (
	SELECT query_name, round(sum(rating/position)/count(rating),2) as quality, count(rating) as tt_rat
	FROM sys.`1211-queries`
	GROUP BY query_name) AS a
LEFT JOIN  (SELECT query_name, count(rating) as rating1
					  FROM sys.`1211-queries`
					  WHERE rating<3
					  GROUP BY query_name) as b on a.query_name=b.query_name
ORDER BY quality DESC;
                      
-- 只要一个表去统计count(rating)& quality, 另一个表去统计<3的就可以，最后join起来再计算




