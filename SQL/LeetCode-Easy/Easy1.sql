[Lee code Easy](https://leetcode.com/problemset/database/?difficulty=Easy)

### 1. Second Highest Salary
```
Write a SQL query to get the second highest salary from the Employee table.

+----+--------+
| Id | Salary |
+----+--------+
| 1  | 100    |
| 2  | 200    |
| 3  | 300    |
+----+--------+
For example, given the above Employee table, the query should return 200 as the second highest salary. If there is no second highest salary, then the query should return null.

+---------------------+
| SecondHighestSalary |
+---------------------+
| 200                 |
+---------------------+
```

Method1: find the highest salary from salaries that less than the highest salary

```MySQL

SELECT MAX(Salary) as SecondHighestSalary 
FROM Employee 
WHERE Salary<(SELECT MAX(Salary) FROM Employee)
```
Method2: use IFNULL & Limit & Offset function return null is there is no value 

```MySQL

SELECT IFNULL((SELECT DISTINCT Salary 
FROM Employee 
ORDER BY Salary DESC 
LIMIT 1,1),null) as SecondHighestSalary 
```

or

```MySQL

SELECT IFNULL((SELECT DISTINCT Salary 
FROM Employee 
ORDER BY Salary DESC 
LIMIT 1 offset 1),null) as SecondHighestSalary 
```

### 2. Employees Earning More Than Their Managers[181]

```
The Employee table holds all employees including their managers. Every employee has an Id, and there is also a column for the manager Id.

+----+-------+--------+-----------+
| Id | Name  | Salary | ManagerId |
+----+-------+--------+-----------+
| 1  | Joe   | 70000  | 3         |
| 2  | Henry | 80000  | 4         |
| 3  | Sam   | 60000  | NULL      |
| 4  | Max   | 90000  | NULL      |
+----+-------+--------+-----------+
Given the Employee table, write a SQL query that finds out employees who earn more than their managers. For the above table, Joe is the only employee who earns more than his manager.

+----------+
| Employee |
+----------+
| Joe      |
+----------+
```


Method1: Using [WHERE] to select from two tables

```MySQL

SELECT a.Name as 'Employee' 
FROM Employee as a, Employee as b
WHERE a.ManagerId=b.Id
AND a.Salary > b.Salary;
```
or

```MySQL

SELECT e.name as Employee 
FROM Employee e 
WHERE e.Salary >(Select e2.Salary from Employee e2 where e2.id=e.ManagerId)
```
Method2: use [JOIN] (更快)
```MySQL

SELECT a.Name as 'Employee' 
FROM Employee as a
JOIN Employee as b
ON a.ManagerId=b.Id
AND a.Salary > b.Salary;
```
```MySQL
SELECT e.Name AS Employee 
FROM Employee e
INNER JOIN Employee m
ON e.ManagerId = m.Id
WHERE e.Salary > m.Salary;
```

知识点： 
Mysql 的执行顺序：From-Join-On-Where-Group by-Avg/Sum-Having-Select-Distinct-Orderby-Limit

筛选可以在on条件里或者where，区别是用outer join时候用on的部分会重新加回来而where就不会


### 3. Duplicate Emails[182]

```
Write a SQL query to find all duplicate emails in a table named Person.

+----+---------+
| Id | Email   |
+----+---------+
| 1  | a@b.com |
| 2  | c@d.com |
| 3  | a@b.com |
+----+---------+
For example, your query should return the following for the above table:

+---------+
| Email   |
+---------+
| a@b.com |
+---------+
Note: All emails are in lowercase.
```


Method1: Using [Group by + Where] to select from two tables

```MySQL

SELECT a.Email from (
    SELECT Email,count(Email) as counts
    FROM Person
    GROUP BY Email) as a
WHERE a.counts>1;
```

Method2: use [Group by + Having] (更快)
```MySQL


SELECT Email
FROM Person
GROUP BY Email
HAVING COUNT(Email) > 1;
```

Method3: use [SELF Join] 
```MySQL

DELETE p1 
FROM Person p1,Person p2
WHERE p1.Email = p2.Email AND p1.Id > p2.Id
```
OR

```MySQL

SELECT DISTINCT a.Email
FROM Person a 
JOIN Person b
ON a.Email = b.Email
AND a.Id <> b.Id
```
知识点： 

Groupby之后having

where 和 join on类同 [select email form p1,p2 where p1.id=p2.id] 等同于 [select email from p1 join p2 on p1.id=p2.id]

### 4. Delete Duplicate Emails[196]

```
Write a SQL query to delete all duplicate email entries in a table named Person, keeping only unique emails based on its smallest Id.

+----+------------------+
| Id | Email            |
+----+------------------+
| 1  | john@example.com |
| 2  | bob@example.com  |
| 3  | john@example.com |
+----+------------------+
Id is the primary key column for this table.
For example, after running your query, the above Person table should have the following rows:

+----+------------------+
| Id | Email            |
+----+------------------+
| 1  | john@example.com |
| 2  | bob@example.com  |
+----+------------------+
Note:

Your output is the whole Person table after executing your sql. Use delete statement.

```


Method1: Using [SELF JOIN] 

```MySQL
DELETE p1 
FROM Person p1,Person p2
WHERE p1.Email = p2.Email AND p1.Id > p2.Id
```

### 5. Customers Who Never Order[183]

```
Suppose that a website contains two tables, the Customers table and the Orders table. Write a SQL query to find all customers who never order anything.

Table: Customers.

+----+-------+
| Id | Name  |
+----+-------+
| 1  | Joe   |
| 2  | Henry |
| 3  | Sam   |
| 4  | Max   |
+----+-------+
Table: Orders.

+----+------------+
| Id | CustomerId |
+----+------------+
| 1  | 3          |
| 2  | 1          |
+----+------------+
Using the above tables as example, return the following:

+-----------+
| Customers |
+-----------+
| Henry     |
| Max       |
+-----------+

```

Method1: Using [LEFT JOIN + IS NUL] 

```MySQL

SELECT Name as Customers 
FROM Customers as c
LEFT JOIN Orders as d ON c.Id=d.CustomerId 
WHERE CustomerId is Null;
```

Method2: use [NOT IN] (更快)
```MySQL

SELECT Name as Customers 
FROM Customers as c
WHERE Id NOT IN (SELECT CustomerId FROM Orders);
```

### 6. Rising Temperature[197]

```
Given a Weather table, write a SQL query to find all dates' Ids with higher temperature compared to its previous (yesterday's) dates.

+---------+------------------+------------------+
| Id(INT) | RecordDate(DATE) | Temperature(INT) |
+---------+------------------+------------------+
|       1 |       2015-01-01 |               10 |
|       2 |       2015-01-02 |               25 |
|       3 |       2015-01-03 |               20 |
|       4 |       2015-01-04 |               30 |
+---------+------------------+------------------+
For example, return the following Ids for the above Weather table:

+----+
| Id |
+----+
|  2 |
|  4 |
+----+

```

Method1: Using [SELF JOIN + DATEDIFF] 

```MySQL

SELECT a.Id FROM Weather as a, Weather as b
WHERE DATEDIFF(a.RecordDate,b.RecordDate)=1 
AND a.Temperature > b.Temperature;


```

Method2: use [WHERE + DATEDIFF] (更快)
```MySQL

SELECT Name as Customers 
FROM Customers as c
WHERE Id NOT IN (SELECT CustomerId FROM Orders);
```
or

```MySQL
SELECT a.Id FROM Weather as a, Weather as b
WHERE TIMESTAMPDIFF(DAY,b.RecordDate,a.RecordDate)=1
AND a.Temperature > b.Temperature;
```

知识点：

DATEDIFF() 函数返回两个日期之间的天数,时间大的放在前面，时间小的放在后面

TIMESTAMPDIFF函数，有参数设置，可以精确到天（DAY）、小时（HOUR），分钟（MINUTE）和秒（SECOND），使用起来比datediff函数更加灵活。对于比较的两个时间，时间小的放在前面，时间大的放在后面。

两个函数放日起的位置相反

--相差1天
select TIMESTAMPDIFF(DAY, '2018-03-20 23:59:00', '2015-03-22 00:00:00');

select DATEDIFF('2015-03-22 00:00:00','2018-03-20 23:59:00');

### 7. Boring Movies[620]

```
X city opened a new cinema, many people would like to go to this cinema. The cinema also gives out a poster indicating the movies’ ratings and descriptions.
Please write a SQL query to output movies with an odd numbered ID and a description that is not 'boring'. Order the result by rating.

 

For example, table cinema:

+---------+-----------+--------------+-----------+
|   id    | movie     |  description |  rating   |
+---------+-----------+--------------+-----------+
|   1     | War       |   great 3D   |   8.9     |
|   2     | Science   |   fiction    |   8.5     |
|   3     | irish     |   boring     |   6.2     |
|   4     | Ice song  |   Fantacy    |   8.6     |
|   5     | House card|   Interesting|   9.1     |
+---------+-----------+--------------+-----------+
For the example above, the output should be:
+---------+-----------+--------------+-----------+
|   id    | movie     |  description |  rating   |
+---------+-----------+--------------+-----------+
|   5     | House card|   Interesting|   9.1     |
|   1     | War       |   great 3D   |   8.9     |
+---------+-----------+--------------+-----------+
```

Method1: Using [MOD] 

```MySQL

SELECT * FROM cinema 
WHERE MOD(id, 2) = 1
AND description <>'boring' 
ORDER BY rating DESC

```
OR

```MySQL

SELECT * FROM cinema 
WHERE id % 2 = 1
AND description NOT LIKE '%boring%'
ORDER BY rating DESC

```

知识点：

MOD(N,M)该函数返回N除以M后的余数. 分请看下面的例子：
偶数：MOD(4, 2) = 0
奇数：MOD(3, 2) = 1

除法：id%2!=0
不等于：<> 或者 !=
模糊查询：NOT LIKE/ LIKE '%boring%'


### 8. Swap Salary[627]

```
Given a table salary, such as the one below, that has m=male and f=female values. Swap all f and m values (i.e., change all f values to m and vice versa) with a single update statement and no intermediate temp table.

Note that you must write a single update statement, DO NOT write any select statement for this problem.

 

Example:

| id | name | sex | salary |
|----|------|-----|--------|
| 1  | A    | m   | 2500   |
| 2  | B    | f   | 1500   |
| 3  | C    | m   | 5500   |
| 4  | D    | f   | 500    |
After running your update statement, the above salary table should have the following rows:
| id | name | sex | salary |
|----|------|-----|--------|
| 1  | A    | f   | 2500   |
| 2  | B    | m   | 1500   |
| 3  | C    | f   | 5500   |
| 4  | D    | m   | 500    |

```

Method1: Using [Update + Case When] 

```MySQL
UPDATE salary SET sex = IF (sex = "m", "f", "m");

```
OR

```MySQL

UPDATE salary
SET
    sex = CASE sex
               WHEN 'm' THEN 'f'
               WHEN 'f' then  'm'
    END;

```

OR


```MySQL

UPDATE salary
SET
    sex = CASE 
              WHEN sex='m' THEN 'f'
              WHEN sex='f' then  'm'
    END;

```

异或的方法

```MySQL

SELECT uid, famount, if(fentrusttype=0,'Buy','Sell')
FROM fentrustlog;
update salary set sex = CHAR(ASCII('f') ^ ASCII('m') ^ ASCII(sex));

```

知识点：

If & Case When 

if的语法是IF(condition, value_if_true, value_if_false)

CASE expressing WHEN condition THEN return
这里expressing 不是必须的，如果有，就是拿来和condition进行比较的，意即如果有expressing，默认将它和WHEN后面的条件进行=比较，如果真，返回THEN后面的结果。下面是有expressing和没有expressing的两种写法：

```MySQL

SELECT uid, famount, if(fentrusttype=0,'Buy','Sell')
FROM fentrustlog;


SELECT uid, famount, case fentrusttype when 0 then 'Buy' else 'sell'
end
FROM fentrustlog;


SELECT uid, famount, case  when fentrusttype=0 then 'Buy' else 'sell'
end
FROM fentrustlog;

```

IfNULL的语法

IFNULL(expr1,expr2)    

如果expr1不是NULL，IFNULL()返回expr1，否则它返回expr2。IFNULL()返回一个数字或字符串值，取决于它被使用的上下文环境。 


```MySQL

SELECT fid,floginname, ifnull(ftelephone,'没有') as phone
FROM fuser
limit 100;

```
NULLIF(expr1,expr2)  的用法：

如果expr1 = expr2 成立 ，那么返回值为NULL，否则返回值为expr1。如果相同就是null，不同返回第一个值

```MySQL

SELECT fid,floginname, femail ,NULLIF(floginname,femail) as SAME
FROM fuser
limit 500;

```
isnull(expr) 的用法：

如expr 为null，那么isnull() 的返回值为 1，否则返回值为 0。 

```MySQL

SELECT fid,floginname, femail ,isnull(ftelephone) as phone
FROM fuser
limit 500;

```

### 9. Consecutive Available Seats

```
Find Consecutive seats
+---------+--------
| seat_id | Free  | 
+---------+--------
|   1     | 1     |   
|   2     | 0     |   
|   3     | 1     |   
|   4     | 1     |
|   5     | 1     |
+---------+--------

```

```MySQL
SELECT DISTINCT c1.seat_id 
FROM cinema AS c1, cinema AS c2 
WHERE c1.free = 1 AND c2.free = 1 
AND (c2.seat_id = c1.seat_id + 1 OR c2.seat_id = c1.seat_id -1) 
ORDER BY c1.seat_id;

```
or
```MySQL
select a.seat_id, a.free, b.seat_id, b.free
from cinema a join cinema b
  on abs(a.seat_id - b.seat_id) = 1
  and a.free = true and b.free = true;
  
```

