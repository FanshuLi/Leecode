SELECT * FROM sys.`1205-trans`;
SELECT * FROM sys.`1205-charge` ;

-- 比较绕，因为2列参照的时间不同，groupby时间不一样，所以要分开join，再根据需要哪个时间决定join的类型

SELECT f1.month, f1.country,IFNULL(approved_count,0) as approved_count,
IFNULL(approved_amount,0) as approved_amount,checkback_count,checlback_amount
FROM (
	SELECT  LEFT(c.trans_date,7) AS month , country, COUNT(trans_id) AS checkback_count,SUM(amount) AS checlback_amount
	FROM sys.`1205-charge` AS c 
	LEFT JOIN sys.`1205-trans` AS t ON t.id=c.trans_id
	GROUP BY  LEFT(c.trans_date,7) , country)  AS f1
LEFT JOIN (
	SELECT  LEFT(t.trans_date,7) AS month, country, SUM(IF(state='approved',1,0)) AS approved_count,
	SUM(IF(state='approved',amount,0)) AS approved_amount
	FROM sys.`1205-trans` AS t 
	LEFT JOIN sys.`1205-charge` AS c ON t.id=c.trans_id
GROUP BY  LEFT(t.trans_date,7) , country) AS f2 
ON f1.month=f2.month;










