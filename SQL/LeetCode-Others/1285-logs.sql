SELECT * FROM sys.`1285-logs`;

SELECT * FROM sys.`1285-logs` as s1
LEFT JOIN sys.`1285-logs` as s2
ON s1.log_id=s2.log_id+1
LEFT JOIN sys.`1285-logs` AS S3
ON s2.log_id=s3.log_id+1
LEFT JOIN sys.`1285-logs` AS S4
ON s3.log_id=s4.log_id+1s2.log_id is not null
where s2.log_id is not null or s3.log_id is not null or s4.log_id is not null；

