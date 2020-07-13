
## Leetcode Medium

-- 177.Nth Highest Salary
-- 第n高的公司
CREATE FUNCTION getNthHighestSalary(N INT) RETURNS INT
BEGIN
  SET N = N - 1;
  RETURN (
      # Write your MySQL query statement below.
      SELECT DISTINCT Salary
      FROM Employee
      ORDER BY Salary DESC
      LIMIT N,1
  );
END

-- 178.Rank Scores


-- 180.Consecutive Numbers (self-joining)

SELECT num FROM 
logs as l1, logs as l2, logs as l3
WHERE l1.id=l2.id-1 AND l2.id=l3.id-1
AND l1.Num=l2.Num AND l2.Num=l3.Num;

-- 184.Department Highest Salary
SELECT d.name as Department, e1.name as Employee,e.salary 
FROM (SELECT departmentid, MAX(salary) as salary FROM Employee GROUP BY departmentid) AS e
LEFT JOIN Department AS D on e.departmentid=d.departmentid
LEFT JOIN Employee as e1 on e1.departmentid=d.departmentid;

-- 534/550.Game Play Analysis III
-- 解题思路：累加和问题，题目要求出每个玩家在某个时期之前玩过的游戏个数累加和。

-- 570 Managers with at Least 5 Direct Reports

-- 570 Managers with at Least 5 Direct Reports
-- selfjoin 按经理id分组
SELECT DISTINCT a.Name FROM sys.`570-direct-reports` AS a 
JOIN sys.`570-direct-reports` AS b ON a.id=b.managerid
GROUP BY a.id
HAVING COUNT(b.id)>=5;

-- 先找id，再找name
SELECT E.Name
FROM Employee AS E
JOIN 
(
    SELECT ManagerId
    FROM sys.`570-direct-reports`
    GROUP BY ManagerId
    HAVING COUNT(Id)>=5
) AS A
ON (E.Id = A.ManagerId);

-- 574 Winning Candidate 
-- 考虑无平局，子循环中用limit会报错，但再加一个子循环就可以
SELECT name 
FROM sys.`574-winner-c` as c
WHERE id in 
(SELECT candidateid FROM 
     (SELECT candidateid  FROM sys.`574-winner-v` 
     GROUP BY candidateid order by count(id) desc LIMIT 1)as n) ;

-- 或者
SELECT name 
FROM sys.`574-winner-c` as c
JOIN
	(SELECT candidateid FROM sys.`574-winner-v` as v
    GROUP BY candidateid
    ORDER BY COUNT(*) DESC
    LIMIT 1) AS s on  c.id = s.candidateid;

-- 若考虑有平局???

-- 578 Get Highest Answer Rate Question 查询回答率最高的问题
-- 回答率 = answer的个数 / show的个数

--求什么比率一般都是：
-- (sum(case when `action` like 'answer' then 1 else 0 end) / sum(case when `action` like 'show' then 1 else 0 end)) as rate

SELECT s.question_id AS `survey_log`
FROM sys.`578-survey` AS s
GROUP BY s.question_id 
ORDER BY SUM(IF(s.action='answer',1,0))/SUM(IF(S.action='show',1,0)) DESC
LIMIT 1;

SELECT question_id AS 'survey_log'
FROM (
    SELECT question_id, 
           SUM(CASE WHEN action='answer' THEN 1 ELSE 0 END) AS num_answer,
           SUM(CASE WHEN action='show' THEN 1 ELSE 0 END) AS num_show
    FROM survey_log
    GROUP BY question_id
    ) AS t
ORDER BY (num_answer / num_show) DESC
LIMIT 0,1;

-- 580 Count Student Number in Departments 统计各专业学生人数
SELECT dept_name, num FROM
department as d
left join (select dept_id, count(student_id) as num from department group by dept_id ) as d1
on d.dept_id=d1.dept_id
order by 2 desc;


SELECT dept_name, count(student_id) as num FROM
department as d
left join department as d1
on d.dept_id=d1.dept_id
group by dept_name
order by 2 desc, 1;

!!!-- 585. Investments in 2016
-- 1. 2015 same; 2. location unique

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
-- 组合类问题可以以一组写，where后加括号为一组，但select后面不能加括号
SELECT SUM(TIV_2016) TIV_2016
FROM sys.`585-invest`
WHERE TIV_2015 IN
	(SELECT TIV_2015  FROM sys.`585-invest` 
	GROUP BY TIV_2015 HAVING COUNT(1)>1)
AND (lat, lon) IN 
	(SELECT lat, lon FROM sys.`585-invest` 
    GROUP BY lat, lon HAVING COUNT(1)=1)


-- 602 Friend Requests II: Who Has the Most Friends 好友申请 II ：谁有最多的好友
SELECT id, SUM(num) as num FROM (
	SELECT requester_id AS id, COUNT(requester_id) AS num FROM sys.`602-request`
	GROUP BY requester_id
UNION 
	SELECT accepter_id AS id , COUNT(accepter_id)  AS num FROM sys.`602-request`
	GROUP BY accepter_id) AS f1
	GROUP BY id
ORDER BY SUM(num) DESC LIMIT 1;

-- or
SELECT t.id, COUNT(t.id) AS num FROM
(SELECT requester_id AS id FROM sys.`602-request`
 UNION ALL
 SELECT accepter_id AS id FROM sys.`602-request`) AS t
GROUP BY t.id
ORDER BY num DESC LIMIT 1;

-- 608 Tree Node 树节点
-- 三类，顶点是root， 上下都有节点的是inner，只有上面有节点的是leaf
-- case when 和 if 可互换，其中可以添加条件
SELECT id, IF(p_id IS NULL,'Root',IF(id IN (SELECT p_id FROM sys.`608-tree`),'Inner','Leaf')) AS Type
FROM sys.`608-tree`;

SELECT id, CASE WHEN p_id IS NULL THEN 'Root'
WHEN id IN (SELECT p_id FROM sys.`608-tree`) THEN 'Inner'
ELSE 'Leaf' END AS Type
FROM sys.`608-tree`;


-- 612 Shortest Distance in a Plane 平面上的最近距离 
-- Using SQRT, POW() functions
SELECT ROUND(
         SQRT( MIN( POWER(p1.x - p2.x, 2) + POWER(p1.y - p2.y, 2) )
        ), 2) AS shortest
FROM point_2d AS p1 INNER JOIN point_2d AS p2
ON p1.x != p2.x OR p1.y != p2.y


-- 614 Second Degree Follower 二级关注者

SELECT F1.follower, COUNT(DISTINCT F2.follower) AS 'num'
FROM sys.`614-follower` AS F1 
JOIN sys.`614-follower` AS F2
ON F1.follower = F2.followee
GROUP BY F1.follower;

!!! -- 626. Exchange Seats 换座位

-- 1045 Customers Who Bought All Products 买下所有产品的客户
-- 本题强调了primary key 和foreign key，故直接可通过顾客「购买的商品种类数」 = 「商品种类总数」筛选。
SELECT customer_id
FROM Customer
GROUP BY customer_id
HAVING COUNT(DISTINCT product_key) = (SELECT COUNT(DISTINCT product_key) FROM Product)


!!! 需要注意-- 1070 Product Sales Analysis III 产品销售分析 III
针对要求输出

-- 错误答案🙅 只需要找到最早出现的的min year，只要一个。 min 只关注一个值，而不是一行值， 会有mismatch
SELECT product_id, MIN(year) AS first_year, quantity, price
FROM Sales
GROUP BY product_id, quantity, price

-- 正确
SELECT product_id, year AS first_year, quantity, price
FROM sys.`1070-product`
WHERE (product_id,year) IN (SELECT product_id, MIN(year) FROM sys.`1070-product` GROUP BY product_id)

-- 1077 Project Employees III 项目员工 III
每个项目组里工作年限最长的人（可能多个）。
SELECT f1.project_id, f2.employee_id 
FROM  sys.`1077-project` AS f1 
JOIN sys.`1077-employee` AS f2 
ON f1.employee_id=f2.employee_id
WHERE  (f1.project_id, f2.experience_years) IN (
	SELECT p.project_id, MAX(e.experience_years)  FROM sys.`1077-project` AS p
	JOIN sys.`1077-employee` AS e ON p.employee_id=e.employee_id
	GROUP BY project_id);

-- 1098 Unpopular Books 小众书籍
选出「去年」销量小于10本的书(有null值)，排除近「一个月内」新上的书。2019-06-23.

SELECT book_id, book_name
FROM books as b join orders as o on b.book_id=o.book_id
WHERE dispatch_date>='2018-06-23' AND dispatch_date<='2019-06-23'
AND available_from < '2019-05-23'
GROUP BY book_id,book_name
Having sum(quantity)<10 OR sum(quantity) is null;


SELECT B.book_id, B.name
FROM books AS B LEFT JOIN orders AS O
ON O.book_id = B.book_id AND O.dispatch_date BETWEEN '2018-06-23' AND '2019-06-23'
WHERE DATEDIFF('2019-06-23', B.available_from) > 30
GROUP BY B.book_id
HAVING SUM(IF(O.quantity IS NULL, 0, O.quantity)) < 10;

-- 1107.New Users Daily Count 每日新用户统计
最近90天内每天「新用户」登录的数量。2019-06-30.

write an SQL query that reports for every date within at most 90 days from today,
 the number of users that logged in for the first time on that date. Assume today is 2019-06-30.

SELECT login_date, COUNT(user_id) FROM (
    SELECT user_id, MIN(activity_date) AS login_date
    FROM traffic
    WHERE activity='login'
     GROUP BY user_id) AS f1
WHERE DATEDIFF('2019-06-30',login_date) <= 90
GROUP BY login_date;

-- 1112 Highest Grade For Each Student 每个同学的最高分
找到每个学生最高的分，最小的课程号，但要匹配，组合查询
Write a SQL query to find the highest grade with its corresponding course for each student. 
In case of a tie, you should find the course with the smallest course_id. 
The output must be sorted by increasing student_id.

SELECT student_id, MIN(course_id), grade
FROM Enrollments
WHERE (student_id,grade) IN (
        SELECT student_id, MAX(grade) AS grade
        FROM enrollments
        GROUP BY student_id)
GROUP BY student_id
ORDER BY student_id;

-- 1126 Active Businesses 活跃业务 (题目很难理解)
跃业务的定义为：大于一个「事件类型」，其「频次」大于该类型的「平均频次」。
 (Business that has more than one event type with occurences greater than the average occurences of 
 that event type among all businesses.)
1. 求均值
2. 找到该类型大于avg的行
3. 找到count>=2的id
Average for 'reviews', 'ads' and 'page views' are (7+3)/2=5, (11+7+6)/3=8, (3+12)/2=7.5 respectively.
Business with id 1 has 7 'reviews' events (more than 5) and 11 'ads' events (more than 8) so it is an active business.

SELECT business_id FROM (
    SELECT business_id, event_type, occurences FROM Events as e1,
    (SELECT event_type, avg(occurences) as o2
    FROM Events
    GROUP BY event_type) as e2 
WHERE  e1.event_type=e2.event_type AND e1.occurences > e2.o2) AS f
GROUP BY business_id
HAVING count(*)>1

-- 标准答案
SELECT business_id
FROM (SELECT a.business_id, a.event_type, a.occurences, b.event_avg  -- sub 2
      FROM Events a LEFT JOIN
        (SELECT event_type, AVG(occurences) event_avg   -- sub 1
         FROM Events
         GROUP BY event_type) b ON
      a.event_type = b.event_type) tmp
WHERE occurences > event_avg
GROUP BY business_id
HAVING COUNT(event_type) > 1;

-- 1132 Reported Posts II
（找到被认为是spam之后被remove的个数）/ 每天的post

1. 找到每天 被remove的spam/总spam
2. avg

SELECT ROUND(AVG(num)*100,2) AS average_daily_percent FROM (
	SELECT action_date,COUNT(b.post_id)/COUNT(a.post_id) AS num
	FROM (
		SELECT * FROM sys.`1132-actions` 
		WHERE action='report' AND extra='spam') AS a
	LEFT JOIN sys.`1132-removals` AS b ON a.post_id=b.post_id
GROUP BY action_date) AS F1;

-- 1164 Product Price at a Given Date

找到在该日期的价格

SELECT * FROM sys.`1164-products`;

SELECT DISTINCT a.product_id, IFNULL(b.new_price,10) AS price
FROM sys.`1164-products` AS a 
LEFT JOIN (
	SELECT product_id, new_price 
	FROM sys.`1164-products` 
	WHERE (product_id,change_date) IN (
		SELECT product_id, MAX(change_date)
		FROM sys.`1164-products` 
		WHERE change_date<='2019-08-16'
		GROUP BY product_id)) AS b ON a.product_id=b.product_id
ORDER BY price DESC;

-- 1174 Immediate Food Delivery II
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

-- 1193 Monthly Transactions I
!!! countif, sumif
SELECT 
	LEFT(trans_date, 7) AS 'month', country, 
    COUNT(id) AS 'trans_count', 
    SUM(IF(state='approved', 1,0)) AS 'approved_count', 
    SUM(amount) AS 'trans_total_amount', 
    IF(state='approved', amount, 0) AS 'approved_total_amount'
FROM Transactions
GROUP BY MONTH(trans_date), country
ORDER BY trans_count DESC;

-- 1204. Last Person to Fit in the Elevator
！！！利用自连接做累计加和
SELECT q1.person_name
FROM sys.`1204-quene` AS q1
JOIN sys.`1204-quene` AS q2 ON q1.turn>=q2.turn 
GROUP BY q1.person_id,q1.person_name, q1.turn
HAVING SUM(q2.weight) =1000;

-- 1205 Monthly Transactions II
!!! 比较绕，因为2列参照的时间不同，groupby时间不一样，所以要分开join，再根据需要哪个时间决定join的类型

Write an SQL query to find for each month and country, 
1. the number of approved transactions 
2. and their total amount,
3. the number of chargebacks 
4. and their total amount.

SELECT * FROM sys.`1205-trans`;
SELECT * FROM sys.`1205-charge` ;

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

-- 1212 Team Scores in Football Tournament

A team receives three points if they win a match (Score strictly more goals than the opponent team).
A team receives one point if they draw a match (Same number of goals as the opponent team).
A team receives no points if they lose a match (Score less goals than the opponent team).

Write an SQL query that selects the team_id, team_name 
and num_points of each team in the tournamentfter all described matches.

 1. judge the winner and Score
 2. host & guest
 3. sum up
-- 用 case when 或者 if

 SELECT t.team_id, t.team_name, IFNULL(SUM(s.score),0) AS num_points
 FROM sys.`1212-teams` AS t
 
 LEFT JOIN (

	 SELECT match_id, host_team AS team, 
	 CASE WHEN host_goals>guest_goals 
	 THEN 3
	 WHEN host_goals=guest_goals 
	 THEN 1
	 ELSE 0
	 END AS score 
	 FROM sys.`1212-matches`

	 UNION 

	 SELECT match_id, guest_team AS team  ,
	 CASE WHEN host_goals>guest_goals 
	 THEN 0
	 WHEN host_goals=guest_goals 
	 THEN 1
	 ELSE 3
	 END AS score
	 FROM sys.`1212-matches`) AS s
 ON t.team_id=s.team
 GROUP BY team_id, team_name
 ORDER BY num_points DESC, team_id;
 
 -- if
 
 SELECT t.team_id, t.team_name, IFNULL(SUM(s.score),0) AS num_points
 FROM sys.`1212-teams` AS t
 LEFT JOIN (

	 SELECT match_id, host_team AS team,IF (host_goals>guest_goals,3, IF(host_goals=guest_goals,1,0)) AS score 
	 FROM sys.`1212-matches`
	 UNION 
	 SELECT match_id, guest_team AS team,IF (host_goals>guest_goals,0, IF(host_goals=guest_goals,1,3)) AS score 
	 FROM sys.`1212-matches`) AS s ON t.team_id=s.team
 GROUP BY team_id, team_name
 ORDER BY num_points DESC, team_id;
 
 -- 1264.  Page Recommendations

 1. find 1 friends (可能在user1_id,也可能在user2_id)
 2.the page your friend like 
 3. not you already like

SELECT page_id AS Recommendaed_page
FROM LIKES
WHERE user_id IN 
((SELECT user2_id FROM friendship WHERE user1_id = 1) OR user_id IN (SELECT user1_id FROM friendship WHERE user2_id=1))
AND page_id NOT IN (SELECT page_id FROM likes WHERE user_id =1);

 -- 1270 All People report to the given managers
-- 有点像链表，一个连接一个

SELECT s1.employee_id FROM sys.`1270-employee` AS s1
LEFT JOIN sys.`1270-employee` AS s2
ON s1.manager_id=s2.employee_id
LEFT JOIN sys.`1270-employee` AS s3
ON s2.manager_id=s3.employee_id
LEFT JOIN sys.`1270-employee` AS s4
ON s3.manager_id=s4.employee_id
WHERE s4.manager_id =1
AND s1.employee_id <>1;

 
 ？？？-- 1285 Find the start and end number of continuous ranges
定位连续值区间的开始值和结束值
找到连续数字的始末




 
