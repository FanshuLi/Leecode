SELECT * FROM sys.`1212-teams`;



 SELECT t.team_id, t.team_name, IFNULL(SUM(s.score),0) AS num_points
 FROM sys.`1212-teams` AS t
 
 LEFT JOIN (

	 SELECT match_id, host_team AS team, 
	 CASE WHEN host_goals>guest_goals 
	 THEN 3
	 WHEN host_goals=guest_goals 
	 THEN 1
	 ELSE 0
	 END AS score 
	 FROM sys.`1212-matches`

	 UNION 

	 SELECT match_id, guest_team AS team  ,
	 CASE WHEN host_goals>guest_goals 
	 THEN 0
	 WHEN host_goals=guest_goals 
	 THEN 1
	 ELSE 3
	 END AS score
	 FROM sys.`1212-matches`) AS s
 ON t.team_id=s.team
 GROUP BY team_id, team_name
 ORDER BY num_points DESC,team_id;
 
 
 
 SELECT t.team_id, t.team_name, IFNULL(SUM(s.score),0) AS num_points
 FROM sys.`1212-teams` AS t
 LEFT JOIN (

	 SELECT match_id, host_team AS team,IF (host_goals>guest_goals,3, IF(host_goals=guest_goals,1,0)) AS score 
	 FROM sys.`1212-matches`
	 UNION 
	 SELECT match_id, guest_team AS team,IF (host_goals>guest_goals,0, IF(host_goals=guest_goals,1,3)) AS score 
	 FROM sys.`1212-matches`) AS s ON t.team_id=s.team
 GROUP BY team_id, team_name
 ORDER BY num_points DESC, team_id;
 
 
 
 
 
 
 
 