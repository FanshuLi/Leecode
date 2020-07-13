SELECT * FROM sys.`602-request`;


SELECT id, SUM(num) as num FROM (
	SELECT requester_id AS id, COUNT(requester_id) AS num FROM sys.`602-request`
	GROUP BY requester_id
UNION 
	SELECT accepter_id AS id , COUNT(accepter_id)  AS num FROM sys.`602-request`
	GROUP BY accepter_id) AS f1
	GROUP BY id
ORDER BY SUM(num) DESC LIMIT 1;

SELECT t.id, COUNT(t.id) AS num FROM
(SELECT requester_id AS id FROM sys.`602-request`
 UNION ALL
 SELECT accepter_id AS id FROM sys.`602-request`) AS t
GROUP BY t.id
ORDER BY num DESC LIMIT 1;