
-- 1070 Product Sales Analysis III 产品销售分析 III
SELECT * FROM sys.`1070-product`;
-- 错误答案🙅 只需要找到最早出现的的min year，只要一个。 min 只关注一个值，而不是一行值， 会有mismatch
SELECT product_id, MIN(year) AS first_year, quantity, price
FROM Sales
GROUP BY product_id, quantity, price;

-- 正确
SELECT product_id, year AS first_year, quantity, price
FROM sys.`1070-product`
WHERE (product_id,year) IN (SELECT product_id, MIN(year) FROM sys.`1070-product` GROUP BY product_id);





