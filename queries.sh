#! /bin/bash

PSQL="psql --username=freecodecamp --dbname=worldcup --no-align --tuples-only -c"

# Do not change code above this line. Use the PSQL variable above to query your database.

echo -e "\nTotal number of goals in all games from winning teams:"
echo "$($PSQL "SELECT SUM(winner_goals) FROM games")"

echo -e "\nTotal number of goals in all games from both teams combined:"
echo $($PSQL "select sum(winner_goals)+sum(opponent_goals) from games")

echo -e "\nAverage number of goals in all games from the winning teams:"
echo $($PSQL "select avg(winner_goals) from games")

echo -e "\nAverage number of goals in all games from the winning teams rounded to two decimal places:"
echo $($PSQL "select round(avg(winner_goals),2) from games")

echo -e "\nAverage number of goals in all games from both teams:"
echo $($PSQL "select avg(winner_goals) + avg(opponent_goals) from games")

echo -e "\nMost goals scored in a single game by one team:"
echo $($PSQL "select winner_goals from games order by winner_goals desc limit 1")

echo -e "\nNumber of games where the winning team scored more than two goals:"
echo $($PSQL "select count(*) from games where winner_goals > 2")

echo -e "\nWinner of the 2018 tournament team name:"
echo $($PSQL "select name from games left join teams on games.winner_id=teams.team_id where year=2018 and round='Final'")

echo -e "\nList of teams who played in the 2014 'Eighth-Final' round:"
$PSQL "SELECT DISTINCT name FROM teams JOIN games ON teams.team_id = games.winner_id OR teams.team_id = games.opponent_id WHERE games.year = 2014 AND games.round = 'Eighth-Final'" | while IFS="" read -r line; do
	echo "$line"
done

echo -e "\nList of unique winning team names in the whole data set:"
$PSQL "select distinct(name) from games left join teams on games.winner_id=teams.team_id order by name" | while IFS="" read -r line; do
	echo "$line"
done

echo -e "\nYear and team name of all the champions:"
$PSQL "select year, name from games left join teams on games.winner_id=teams.team_id where round='Final' order by year" | while IFS="" read -r line; do
	echo "$line"
done

echo -e "\nList of teams that start with 'Co':"
$PSQL "select name from teams where name like 'Co%'" | while IFS="" read -r line; do
	echo "$line"
done
