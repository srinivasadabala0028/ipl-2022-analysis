SELECT * FROM ipl_ball_by_ball_2022
SELECT * FROM iplll  

-- which player has won the mosts player of match and how many times 
select Player_of_Match, count(Player_of_Match) as times 
from iplll 
group by Player_of_Match
order by times desc limit 1 

--are there 'any' superovers in  the season 

select venue,WinningTeam,SuperOver from iplll where SuperOver='Y'

--which team has won by more runs and wickets and who got player of the match 
select WinningTeam,max(margin),Player_of_Match from iplll where WonBy='Runs'
select WinningTeam,max(margin),Player_of_Match from iplll where WonBy='Wickets'

--which team has won the most toss 
select TossWinner,count(TossWinner) from iplll group by TossWinner order by TossWinner desc
limit 1

--who is the orange cap holder 
select batter as orange_cap,sum(batsman_run) as runs  from ipl_ball_by_ball_2022 group by batter order by runs desc limit 1 

--who is the purple cap holder 
select bowler,sum(isWicketDelivery) as wickets from ipl_ball_by_ball_2022 group by bowler order by wickets desc limit 1

--how many caughts were taken and which player has taken most of the catches 
with cte as 
(select fielders_involved,count(fielders_involved)  as caughtes from ipl_ball_by_ball_2022 where kind='caught'group by fielders_involved 
 order by caughtes desc 
)
select *, sum(caughtes) as total_caughtes  from cte

-- how many extras  are there in ipl season and which player has given more extras 
with ctes as
(
select bowler,count(extra_type) as extras  from ipl_ball_by_ball_2022 
where extra_type not in('NA') 
GRoup by bowler 
order by extras desc 
)
select *,sum(extras) from ctes 

-- in which match more extras are thrown 
with cyte as 
(
select iplll.MatchNumber, iplll.Team1, iplll.Team2 , count(ipl_ball_by_ball_2022.extra_type) as extras,
iplll.ID ,
 rank() over ( partition by iplll.ID ORDER  by count(ipl_ball_by_ball_2022.extra_type) desc) as ra
from ipl_ball_by_ball_2022 
join iplll
on  ipl_ball_by_ball_2022.ID=iplll.ID
where ipl_ball_by_ball_2022.extra_type not in ('NA')
group by iplll.ID 
order by extras desc
)
select *,max(extras) from cyte where ra=1 

-- which player has got more duck outs 
with ru as
 (
 select ID,batter,sum(batsman_run) as run 
 from ipl_ball_by_ball_2022 group by ID,batter
)
select *,count(run) as ducks from ru where run=0 group by batter order by ducks desc

-- how many teams has choosen batting or bowling after winning the toss 
select TossDecision,count(TossDecision) as decision from iplll group by TossDecision 

--Find the team that scored the highest total runs in a single match during the entire IPL 2022 season.
select i.ID,i.MatchNumber,p.BattingTeam,sum(p.batsman_run) as runs  from 
iplll i 
join ipl_ball_by_ball_2022 p
on i.ID=p.ID 
group by p.BattingTeam,i.ID order by runs desc limit 1 

--Identify the bowler with the best bowling economy rate (runs conceded per over) in the powerplay overs (first 6 overs) of the matches.
select i.ID,i.Team1,i.Team2,p.bowler,sum(total_run) as runs from 
iplll i 
join ipl_ball_by_ball_2022 p 
on i.ID=p.ID 
where p.overs < 5 group by p.bowler,i.ID order by runs 

--Identify the match with the highest number of sixes hit by both teams combined.
with mat as 
(select i.ID,i.Team1,i.Team2,count(p.batsman_run) as sixes, rank() over(order by count(p.batsman_run) desc) as ra from iplll i 
join ipl_ball_by_ball_2022 p on i.ID=p.ID
where p.batsman_run=6 group by i.ID order by sixes desc
)
select * from mat where ra=1

--Find the player who scored the most runs in a single over of any match in the tournament
with mach as 
(
select ID,batter,overs,sum(batsman_run) as runs  from ipl_ball_by_ball_2022 group by overs,id,batter
order by runs desc 
)
select id,batter,overs,max(runs) from mach

-- Determine the bowler who took the most number of wickets in the death overs (16th to 20th over) of the matches.
with wic as 
(select ID,bowler,count(isWicketDelivery) as wickets,dense_rank() over(order by count(isWicketDelivery) desc ) as ra
 from ipl_ball_by_ball_2022 
where isWicketDelivery=1 and overs in (15,16,17,18,19)
group by ID,bowler order by wickets desc
 )
 select bowler,wickets from wic where ra=1
 
-- Determine the player who bowled the most number of dot balls (deliveries without any runs scored) in the tournament.
select bowler,count(batsman_run) as dot_balls 
from ipl_ball_by_ball_2022 where batsman_run=0 group by bowler order by dot_balls desc

-- in which match most number of dot balls are thrown by which bowler 
select p.ID,p.bowler,i.Team1,i.Team2,count(p.batsman_run) as dot_balls 
from iplll i join ipl_ball_by_ball_2022 p on i.ID=p.ID
where p.batsman_run=0 group by p.bowler,p.ID order by dot_balls desc

-- Find the team with the highest run rate in the powerplay overs (first 6 overs) of the matches.
select ID,BattingTeam,sum(batsman_run) as runs  from ipl_ball_by_ball_2022 where overs in (0,1,2,3,4,5) 
group by ID,BattingTeam order by runs desc 


















 
