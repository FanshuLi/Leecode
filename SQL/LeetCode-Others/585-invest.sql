SELECT * FROM sys.`585-invest`;

-- 1.selfjoin后会有重复 （此种方法仅适用于tiv_2016没有重复值）

SELECT SUM(Distinct a.TIV_2016)
FROM sys.`585-invest` as a join sys.`585-invest` as b
ON a.pid <> b.pid and a.TIV_2015=b.TIV_2015 
AND a.pid not in (
SELECT c.pid
FROM sys.`585-invest`  as c join sys.`585-invest`  as d
ON c.pid <> d.pid and c.lat=d.lat and c.lon=d.lon);

-- 2.这个更容易理解

SELECT SUM(TIV_2016) 
From sys.`585-invest` 
WHERE pid in (SELECT Distinct a.pid 
	FROM sys.`585-invest` as a join sys.`585-invest` as b
	ON a.pid <> b.pid and a.TIV_2015=b.TIV_2015)
AND pid not in (
			SELECT c.pid
			FROM sys.`585-invest`  as c join sys.`585-invest`  as d
			ON c.pid <> d.pid and c.lat=d.lat and c.lon=d.lon);


-- 3.利用concat （需要加逗号，不然可能会有问题，不如直接用组合形式）
SELECT SUM(TIV_2016) AS TIV_2016
FROM sys.`585-invest`
WHERE TIV_2015 IN 
    (
        SELECT TIV_2015
        FROM sys.`585-invest`
        GROUP BY TIV_2015
        HAVING COUNT(*) > 1
    )
AND CONCAT(LAT, ',', LON) IN 
    (
        SELECT CONCAT(LAT, ',', LON)
        FROM sys.`585-invest`
        GROUP BY LAT,LON
        HAVING COUNT(*) = 1
    )
;

-- 4. 最优解：利用groupby+count （一个要唯一，一个要有重复值）
SELECT SUM(TIV_2016) TIV_2016
FROM sys.`585-invest`
WHERE TIV_2015 IN
	(SELECT TIV_2015  FROM sys.`585-invest` 
	GROUP BY TIV_2015 HAVING COUNT(1)>1)
AND (lat, lon) IN 
	(SELECT lat, lon FROM sys.`585-invest` 
    GROUP BY lat, lon HAVING COUNT(1)=1)












