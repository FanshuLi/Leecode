
-- 1241.Number of Comments per Post
-- Write an SQL query to find number of comments per each post.

SELECT * FROM sys.`1241-sub`;

SELECT post_id, IFNULL(num,0) AS number_of_comments FROM (
SELECT DISTINCT sub_id AS post_id 
FROM  sys.`1241-sub`
WHERE parent_id=999) AS a
LEFT JOIN (SELECT parent_id, COUNT(DISTINCT sub_id) AS num
FROM sys.`1241-sub` 
WHERE parent_id IS NOT NULL
GROUP BY parent_id) AS b
ON a.post_id=b.parent_id
ORDER BY post_id;
