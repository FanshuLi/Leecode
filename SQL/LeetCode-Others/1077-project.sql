-- 1077.(Medium) Project Employees III
-- 每个项目组里工作年限最长的人（可能多个）。
SELECT * FROM sys.`1077-employee`;
SELECT * FROM sys.`1077-project`;

SELECT f1.project_id, f2.employee_id 
FROM  sys.`1077-project` AS f1 
JOIN sys.`1077-employee` AS f2 
ON f1.employee_id=f2.employee_id
WHERE  (f1.project_id, f2.experience_years) IN (
	SELECT p.project_id, MAX(e.experience_years)  FROM sys.`1077-project` AS p
	JOIN sys.`1077-employee` AS e ON p.employee_id=e.employee_id
	GROUP BY project_id);
