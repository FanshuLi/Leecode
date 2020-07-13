-
-- Write an SQL query that reports the buyers who have bought S8 but not iPhone. 
-- Note that S8 and iPhone are products present in the Product table

SELECT * FROM sys.`1082-product`;
SELECT * FROM sys.`1082-sales`;

-- 1082.Sales Analysis I
-- Write an SQL query that reports the best seller by total sales price, If there is a tie, report them all.
SELECT seller_id
FROM sys.`1082-sales`
GROUP BY seller_id
HAVING sum(price)= (SELECT SUM(PRICE) FROM sys.`1082-sales` GROUP BY seller_id ORDER BY SUM(PRICE) DESC LIMIT 1);

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
                                      
SELECT p.product_id,p.product_name
FROM sys.`1082-product` as p
LEFT JOIN sys.`1082-sales`  AS s
ON p.product_id=s.product_id
GROUP BY p.product_id,p.product_name
HAVING min(s.sales_date)>'2019-01-01' 
AND max(s.sales_date)<'2019-03-31' ;
