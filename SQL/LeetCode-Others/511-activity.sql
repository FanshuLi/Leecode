
SELECT * FROM sys.511Activity;

-- 511 Game Play Analysis I: Write an SQL query that reports the first login date for each player.

SELECT player_id, MIN(event_date) AS first_login 
FROM sys.511Activity
GROUP BY player_id
ORDER BY player_id;

-- 512 Game Play Analysis II: Write a SQL query that reports the device that is first logged in for each player.

-- 方法一： join
SELECT f1.player_id, f2.device_id FROM 
(SELECT player_id, MIN(event_date) AS first_log FROM sys.511Activity GROUP BY player_id) AS f1
,sys.511Activity AS f2 
WHERE f1.player_id=f2.player_id
AND f1.first_log=f2.event_date
ORDER BY f1.player_id;

-- 方法二：以2个组合为筛选条件
SELECT player_id, device_id
FROM sys.511Activity
WHERE (player_id, event_date) IN (SELECT player_id, MIN(event_date) FROM sys.511Activity GROUP BY player_id)
ORDER BY player_id;


-- 534.Game Play Analysis III: Write an SQL query that reports for each player and date, (累计的sum)
-- how many games played so far by the player. That is, the total number of games played by the player until that date. 
-- 自连接的妙用，可以根据一个条件对另一个指标进行逐步累计
-- 以主表为基准，小于该日期的加和

SELECT 
    a.player_id, a.event_date, SUM(b.games_played)
FROM
    sys.511Activity AS a
        LEFT JOIN
    sys.511Activity AS b ON a.player_id = b.player_id
        AND a.event_date >= b.event_date
GROUP BY a.player_id , a.event_date
ORDER BY a.player_id , a.event_date;

SELECT
    a.player_id,
    a.event_date,
    SUM(b.games_played) games_played_so_far
FROM
    sys.511Activity a LEFT JOIN sys.511Activity b ON 
    b.player_id = a.player_id AND
    b.event_date <= a.event_date  # 自连接 a对b 一对多
GROUP BY
    a.player_id,
    a.event_date;
    
-- 550.Game Play Analysis IV: Write an SQL query that reports the fraction of players that logged in again on the day after the day they first logged in, 
-- rounded to 2 decimal places. In other words, you need to count the number of players that logged in for at least two consecutive days 
-- starting from their first login date, then divide that number by the total number of players.

SELECT 
    ROUND(COUNT(DISTINCT f1.player_id) / COUNT(DISTINCT f2.player_id),2)
FROM
    (SELECT 
        a.player_id
    FROM
        sys.511Activity AS a
    JOIN sys.511Activity AS b ON a.player_id = b.player_id AND DATEDIFF(a.event_date, b.event_date) = 1) AS F1,
    
sys.511Activity AS F2;


SELECT
    ROUND(
        COUNT(b.event_date)/ COUNT(a.player_id),
        2) fraction
FROM
    Activity a LEFT JOIN Activity b ON 
    b.player_id = a.player_id AND
    DATEDIFF(b.event_date,a.event_date) = 1 #b作a的次日
WHERE #first day
    (a.player_id,a.event_date) IN (SELECT player_id, MIN(event_date)
                                   FROM Activity
                                   GROUP BY player_id);





-- 关于join的结果分析

-- 1.如果是1对1，left/inner/right join 都一样
-- 2.如果是1对多，join会返回所有一样的行（以多的那个为准），left/right 决定是加上左边/右边 多出来的

-- 第一种情况： 左边 a , (b) ; 右边 a,a,c

-- left/inner join 都会返回所有含有（多行）该id的行，right join会返回多的所有值导致会有大量空值

SELECT * FROM (
SELECT player_id, player_name as a1,device_id as a2 FROM sys.511Activity AS a
WHERE player_name='Andy') AS a
LEFT JOIN sys.511Activity AS b ON a.player_id=b.player_id;


-- 第二种情况： 左边 a, b, c; 右边 a,a,b

-- right/inner join 都会返回所有含有（多行）该id的行，left join会返回多的所有值导致会有大量空值
SELECT * FROM   sys.`607-salesperson` AS s
LEFT JOIN sys.`607-orders`AS o ON s.sales_id=o.sales_id;



-- 3.如果是多对一，和一对多相比，将left/right join 反过来即可
-- right/inner join  效果相同，都会返回（多行）该id的行，left 和上面right join 效果类似，会有空值
SELECT * FROM sys.511Activity AS a
right JOIN (SELECT player_id, player_name,device_id FROM sys.511Activity AS a
WHERE player_name='Andy') AS b ON a.player_id=b.player_id;

-- 4.如果是多对多, 例如，左边：a,a,b; 右边 a,b,b; join共同的部分都一样，会以a,a,b,b出现，剩下left/right join就会按照左右多出来的的东西加上去

-- 例如左边a,a,b,c， left join就会变成 a,a,b,b,c

-- 例如右边a,a,b,d， right join就会变成 a,a,b,b,d
SELECT * FROM sys.511Activity AS a
INNER JOIN sys.511Activity AS b
ON a.player_id=b.player_id;

-- left join 排列顺序按照左边的表列出，right join 排列顺序会按照右边表的顺序排列





