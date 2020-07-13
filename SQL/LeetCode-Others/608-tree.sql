SELECT * FROM sys.`608-tree`;

SELECT id, IF(p_id IS NULL,'root',IF(id IN (SELECT p_id FROM sys.`608-tree`),'inner','leaf')) AS type
FROM sys.`608-tree`;