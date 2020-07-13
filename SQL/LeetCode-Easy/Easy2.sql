# Leetcode Easy

-- 175.Combine Two Tables

SELECT P.FirstName, P.LastName, A.City, A.State 
FROM Person AS p, Address AS a
WHERE p.PersonId=a.PersonId;

-- 176.Second Highest Salary

SELECT MAX(Salary) FROM Employee
WHERE Salary < (SELECT MAX(salary) FROM employee);

-- 181.Employees Earning More Than Their Managers
SELECT e1.name AS employee 
FROM Employee AS e1
JOIN  Employee AS e2
ON e1.managerid=e2.id
AND e1.salary>e2.salary
HAVING e2.salary IS NOT NULL;


-- 182.Duplicate Emails

SELECT email FROM person
GROUP BY email 
HAVING COUNT(email)>1;

-- 183.Customers Who Never Order

SELECT Name AS Customers 
FROM Customers AS c
WHERE Id NOT IN (SELECT CustomerId FROM Orders);

-- 196.Delete Duplicate Emails

DELETE p1 
FROM Person p1,Person p2
WHERE p1.Email = p2.Email AND p1.Id > p2.Id;

-- 197.Rising Temperature

SELECT w1.id FROM Weather AS w1,Weather AS w2
WHERE DATEDIFF(W1.RecordDate,w2.RecordDate)=1
AND w1.temperature>w2.temperature;

-- 577.Employee Bonus
SELECT name, bonus FROM Employee AS e
LEFT JOIN bonus AS b ON e.empID=b.empID
WHERE bonus IS NULL OR bonus <1000;

-- 584.Find Customer Referee
SELECT name FROM Customer
WHERE referee_id <> 2 OR referee_id IS NULL

-- 586.Customer Placing the Largest Number of Orders 
-- 不考虑并列
SELECT customer_number FROM Orders
GROUP BY customer_number 
ORDER BY count(order_number) DESC
LIMIT 1;

-- 考虑并列
SELECT customer_number FROM Orders
GROUP BY customer_number 
HAVING count(customer_number)= (SELECT COUNT(order_number) FROM Orders GROUP BY customer_number ORDER BY COUNT(order_number) DESC LIMIT 1)

-- 595.Big Countries
SELECT name,population,area FROM World
WHERE area> 3000000 OR population>25000000

-- 596.Classes More Than 5 Students
SELECT class FROM courses
GROUP BY class
HAVING count(distinct student) >= 5;

-- 597.Friend Requests I: Overall Acceptance Rate
SELECT ROUND(
            IFNULL(
                    COUNT(DISTINCT SENDER_ID,SNED_TO_ID)/COUNT(DISTINCT REQUESTER_ID, ACCEPTER_ID),0,2) as accept_rate
FROM friend_request, request_accepted

!!!-- 603.Consecutive Available Seats
-- 其实相差一就是前后都有可能，所以找到左右的数字再去重 （针对这种连续啊，或者自身比较的题，都是自连接）
SELECT DISTINCT c1.seat_id
FROM sys.`603-Cinema` AS c1, sys.`603-Cinema` AS c2
WHERE 
(c1.seat_id=c2.seat_id-1 OR c1.seat_id=c2.seat_id+1) 
AND  c2.free=1 AND C1.free=1
ORDER BY seat_id;
--或者
SELECT DISTINCT c1.seat_id
FROM sys.`603-Cinema` AS c1, sys.`603-Cinema` AS c2
WHERE 
ABS(c1.seat_id-c2.seat_id)=1 
AND  c2.free=1 AND C1.free=1
ORDER BY seat_id;
--如果直接join的话会得到横着的表，但如果改为前后的话，就可以有重复值并且在一个表中提现


-- 607.Sales Person （能不用join就不用，多对一，一对多关系容易出错）
-- Output all the names in the table salesperson, who didn’t have sales to company 'RED'.
SELECT name FROM sys.`607-salesperson`
WHERE sales_id NOT IN (SELECT sales_id FROM sys.`607-orders`  WHERE com_id NOT IN 
(SELECT com_id FROM sys.`607-company` WHERE name='RED' ));

-- 610.Triangle Judgement
SELECT x,y,z, IF (x+y>z AND x+z>y AND y+z>x, 'Yes','No') AS Triangle
FROM Triangle

SELECT
    *
    , (CASE 
       WHEN (x<y+z AND y<x+z AND z<x+y) THEN 'Yes'
       ELSE 'No'
       END) triangle
FROM
    triangle

-- 613.Shortest Distance in a Line
SELECT min(abs(a.x-b.x)) as shortest FROM point as a, point as b
WHERE a.x <> b.x

-- 619.Biggest Single Number
-- max函数如果没有会返回null
SELECT MAX(NUM),NULL FROM my_numbers
WHERE NUM IN (
SELECT NUM FROM my_numbers
GROUP BY NUM
HAVING COUNT(NUM) = 1)

-- 620.Not Boring Movies
SELECT * FROM Cinema
WHERE id%2 <> 0
AND description <> 'boring'
ORDER BY rating DESC;

-- 627.Swap Salary

UPDATE salary SET sex = if(sex = 'm', 'f','m');

UPDATE salary SET sex  = (CASE WHEN sex = 'm' THEN 'f' ELSE 'm' END)

-- 1050.Actors and Directors Who Cooperated At Least Three Times
-- 针对pair出现的，可以group by 2个元素
SELECT actor_id, director_id 
FROM ActorDirector
GROUP BY actor_id, director_id
HAVING count(timestamp)>=3

-- 1068.Product Sales Analysis I
SELECT Product_name, year, price
FROM sales as s, product as p
WHERE s.product_id=p.product_id

-- 1069.Product Sales Analysis II
SELECT product_id, sum(quantity)
FROM sales
GROUP BY product_id

-- 1075.Project Employees I
SELECT p.project_id, ROUND(SUM(s.experience_years)/count(distinct p.employee_id),2) as average_years
FROM project as p left join employee as e
on p.employee_id = e.employee_id
GROUP by p.project_id;

-- 1076.Project Employees II
SELECT projet_id FROM project
GROUP BY project_id
ORDER BY COUNT(*) DESC
LIMIT 1

-- 如果有多个最大值
SELECT project_id
FROM Project
GROUP BY project_id
HAVING COUNT(employee_id) = (SELECT COUNT(employee_id)
                            FROM Project
                            GROUP BY project_id
                            ORDER BY COUNT(employee_id) DESC
                            LIMIT 1)

-- 1082.Sales Analysis I
-- Write an SQL query that reports the best seller by total sales price, If there is a tie, report them all.
SELECT seller_id
FROM sales
GROUP BY seller_id
HAVING sum(price)= (SELECT SUM(PRICE) FROM SALES GROUP BY seller_id ORDER BY SUM(PRICE) DESC LIMIT 1)

-- 1083.Sales Analysis II
-- Write an SQL query that reports the buyers who have bought S8 but not iPhone. Note that S8 and iPhone are products present 
-- in the Product table.

-- 思路： 可以先找到买了s8的，再在这里排除买了ipone的
SELECT buyer_id
FROM sys.`1082-sales`
WHERE product_id IN (SELECT PRODUCT_ID FROM sys.`1082-product` WHERE Product_name = 'S8')
AND buyer_id NOT IN (SELECT buyer_id FROM sys.`1082-sales`
WHERE product_id IN (SELECT product_id FROM sys.`1082-product` WHERE Product_name='iPhone') );

-- 或者

SELECT buyer_id
FROM sys.`1082-sales`
WHERE buyer_id NOT IN (SELECT buyer_id FROM sys.`1082-sales`
WHERE product_id IN (SELECT product_id FROM sys.`1082-product` WHERE Product_name='iPhone'))
AND buyer_id IN (SELECT buyer_id FROM sys.`1082-sales`
WHERE product_id IN (SELECT product_id FROM sys.`1082-product` WHERE Product_name='S8'));

-- 1084.Sales Analysis III
-- Write an SQL query that reports the products that were only sold in spring 2019. 
-- That is, between 2019-01-01 and 2019-03-31 inclusive.

SELECT *
FROM sys.`1082-product`
WHERE product_id in (SELECT product_id 
FROM sys.`1082-sales` WHERE sales_date between '2019-01-01' and '2019-03-31')
AND product_id not in (SELECT product_id FROM sys.`1082-sales` 
									  WHERE sales_date<'2019-01-01' or sales_date>'2019-03-31');

-- 或者 直接聚合找到最大最小                                
SELECT p.product_id,p.product_name
FROM sys.`1082-product` as p
JOIN sys.`1082-sales`  AS s
ON p.product_id=s.product_id
GROUP BY p.product_id,p.product_name
HAVING min(s.sales_date)>'2019-01-01' 
AND max(s.sales_date)<'2019-03-31' ;

-- 1113.Reported Posts
SELECT extra as report_reason, count(distinct post_id) as report_count
FROM actions
WHERE action='report' and action_date='2019-07-04'
GROUP BY extra;

-- 1141.User Activity for the Past 30 Days I

SELECT activity_date, COUNT(DISTINCT USER_ID) as active_users
FROM activity
WHERE activity_date between date_sub('2019-07-27',interval 30 Day) and '2019-07-27'
GROUP BY activity_date;

SELECT activity_date, COUNT(DISTINCT USER_ID) as active_users
FROM activity
WHERE DATEDIFF('2019-07-27',activity_date)<30 AND activity_date<='2019-07-27'
GROUP BY activity_date;

-- 1142.User Activity for the Past 30 Days II
SELECT ROUND(COUNT(DISTINCT session_id)/ count(distinct user_id),2) AS average_session_per_user
FROM activity
WHERE DATEDIFF('2019-07-27',activity_date)<30 AND activity_date<='2019-07-27';

-- 1148.Article Views I
-- Write an SQL query to find all the authors that viewed at least one of their own articles, 
-- sorted in ascending order by their id.
SELECT distinct author_id 
FROM Views
WHERE author_id=viewer_id
ORDER BY author_id;

-- 1173.Immediate Food Delivery I
SELECT ROUND(COUNT(b.ID)/COUNT(Delivery_ID),2)
FROM Delivery,(SELECT count(distinct Customer_id) AS ID FROM Delivery
WHERE order_date=customer_pref_delivery_date) as b

-- 1179.Reformat Department Table
-- 这里的聚合函数没有什么意义，sum/min/max 都可以
select id, 
	sum(case when month = 'jan' then revenue else null end) as Jan_Revenue,
	sum(case when month = 'feb' then revenue else null end) as Feb_Revenue,
	sum(case when month = 'mar' then revenue else null end) as Mar_Revenue,
	sum(case when month = 'apr' then revenue else null end) as Apr_Revenue,
	sum(case when month = 'may' then revenue else null end) as May_Revenue,
	sum(case when month = 'jun' then revenue else null end) as Jun_Revenue,
	sum(case when month = 'jul' then revenue else null end) as Jul_Revenue,
	sum(case when month = 'aug' then revenue else null end) as Aug_Revenue,
	sum(case when month = 'sep' then revenue else null end) as Sep_Revenue,
	sum(case when month = 'oct' then revenue else null end) as Oct_Revenue,
	sum(case when month = 'nov' then revenue else null end) as Nov_Revenue,
	sum(case when month = 'dec' then revenue else null end) as Dec_Revenue
from department
group by id
order by id；

SELECT 
    id, 
    MAX(CASE WHEN month = 'Jan' THEN revenue ELSE null END) AS Jan_Revenue,
    MAX(CASE WHEN month = 'Feb' THEN revenue ELSE null END) AS Feb_Revenue,
    MAX(CASE WHEN month = 'Mar' THEN revenue ELSE null END) AS Mar_Revenue,
    MAX(CASE WHEN month = 'Apr' THEN revenue ELSE null END) AS Apr_Revenue,
    MAX(CASE WHEN month = 'May' THEN revenue ELSE null END) AS May_Revenue,
    MAX(CASE WHEN month = 'Jun' THEN revenue ELSE null END) AS Jun_Revenue,
    MAX(CASE WHEN month = 'Jul' THEN revenue ELSE null END) AS Jul_Revenue,
    MAX(CASE WHEN month = 'Aug' THEN revenue ELSE null END) AS Aug_Revenue,
    MAX(CASE WHEN month = 'Sep' THEN revenue ELSE null END) AS Sep_Revenue,
    MAX(CASE WHEN month = 'Oct' THEN revenue ELSE null END) AS Oct_Revenue,
    MAX(CASE WHEN month = 'Nov' THEN revenue ELSE null END) AS Nov_Revenue,
    MAX(CASE WHEN month = 'Dec' THEN revenue ELSE null END) AS Dec_Revenue
FROM Department
GROUP BY id

-- 1211.Queries Quality and Percentage
-- 只要一个表去统计count(rating)& quality, 另一个表去统计<3的就可以，最后join起来再计算
SELECT a.query_name,quality, round(rating1/ tt_rat*100,2) as poor_query_percentage FROM (
	SELECT query_name, round(sum(rating/position)/count(rating),2) as quality, count(rating) as tt_rat
	FROM sys.`1211-queries`
	GROUP BY query_name) AS a
LEFT JOIN  (SELECT query_name, count(rating) as rating1
					  FROM sys.`1211-queries`
					  WHERE rating<3
					  GROUP BY query_name) as b on a.query_name=b.query_name
ORDER BY quality DESC;
                      

-- 1241.Number of Comments per Post
-- null 值是post。
-- parent_id is null for posts.； parent_id for comments is sub_id for another post in the table.
SELECT post_id, IFNULL(num,0) AS number_of_comments FROM (
SELECT DISTINCT sub_id AS post_id 
FROM  sys.`1241-sub`
WHERE parent_id is null ) AS a
LEFT JOIN (SELECT parent_id, COUNT(DISTINCT sub_id) AS num
FROM sys.`1241-sub` 
WHERE parent_id IS NOT NULL
GROUP BY parent_id) AS b
ON a.post_id=b.parent_id
ORDER BY post_id;


-- 1251.Average Selling Price (针对日期区间的join)
SELECT u.product_id, round(sum(price*units)/sum(units),2) as average_price
FROM UnitsSold AS U, Prices AS P
WHERE  u.product_id=p.product_id 
AND u.purchase_date between p.start_date and p.end_date
GROUP BY u.product_id;

SELECT u.product_id, round(sum(price*units)/sum(units),2) as average_price
FROM UnitsSold AS U JOIN  Prices AS P ON  u.product_id=p.product_id 
AND u.purchase_date between p.start_date and p.end_date
GROUP BY u.product_id,
