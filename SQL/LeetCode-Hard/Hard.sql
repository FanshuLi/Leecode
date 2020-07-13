
[Leetcode Hard](https://leetcode.com/problemset/all/?difficulty=Hard)

### 1. 中位数

找中位数有两种思路：
1. 一种是找出小于中位数的数的个数x，和大于中位数的数的个数y，因为这列数中可以出现值相等的情况，则（x-y）的绝对值小于等于1。

2. 另一种是对每一个数进行排序，值相同的数也赋予不同的排名，找到排名是中间的那个数，首先要知道这列数有多少个数。假设这列数有N个数，则最中间的排名通常在（ceiling(N/2), floor(N/2)+1) 之间（这个适用于奇数个个数和偶数个个数的情况）。


```
Write a SQL query to find the median salary of each company. Bonus points if you can solve it without using any built-in SQL functions.
+-----+------------+--------+
|Id   | Company    | Salary |
+-----+------------+--------+
|1    | A          | 2341   |
|2    | A          | 341    |
|3    | A          | 15     |
|4    | A          | 15314  |
|5    | A          | 451    |
|6    | A          | 513    |
|7    | B          | 15     |
|8    | B          | 13     |
|9    | B          | 1154   |
|10   | B          | 1345   |
|11   | B          | 1221   |
|12   | B          | 234    |
|13   | C          | 2345   |
|14   | C          | 2645   |
|15   | C          | 2645   |
|16   | C          | 2652   |
|17   | C          | 65     |
+-----+------------+--------+
```

Method1: 

```MySQL

select min(e3.Id) as Id, e3.Company, e3.Salary
from (
select e.Id as Id, e.Company as Company, e.Salary as Salary
from Employee e
having abs((select count(e1.Salary)
            from Employee e1
            where e1.Salary < e.Salary
           and e1.Company = e.Company) - (select count(e2.Salary)
                                           from Employee e2
                                           where e2.Salary > e.Salary
                                         and e2.Company = e.Company)) <= 1
order by e.Company, e.Salary) as e3
group by e3.Company, e3.Salary
```
Method2: 

```MySQL

select e1.Id, e1.Company, e1.Salary
from
(select Id,Company, Salary, 
If(@comp = Company, @r:=@r+1, @r:=1) as rank, @comp:= Company
from Employee, (select @r:=0, @comp:=0) r
order by Company, Salary, Id) e1,

(select Company, count(*) as max_rank
from Employee
group by Company) e2
where e1.Company = e2.Company
and e1.rank in (ceiling(e2.max_rank/2),floor(e2.max_rank/2)+1)

```
