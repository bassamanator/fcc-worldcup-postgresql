#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

# VAR=$($PSQL "")

echo $($PSQL "truncate teams, games;")

echo -e "\n~~ Populating teams table ~~"

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS; do
  if [[ $YEAR != year ]]; then
    # echo $YEAR $ROUND $WINNER $OPPONENT $WINNER_GOALS $OPPONENT_GOALS
    CHECK_TEAM=$($PSQL "SELECT * from teams where name='$WINNER'")
    # if WINNER NOT in table
    if [[ -z $CHECK_TEAM ]]; then
      # add WINNER
      INSERT_RESULT=$($PSQL "insert into teams(name) values('$WINNER')")
      if [[ $INSERT_RESULT == "INSERT 0 1" ]]; then
        echo "Inserted into teams, $WINNER"
      fi
    fi

    CHECK_TEAM=$($PSQL "SELECT * from teams where name='$OPPONENT'")
    # if OPPONENT NOT in table
    if [[ -z $CHECK_TEAM ]]; then
      # add OPPONENT
      INSERT_RESULT=$($PSQL "insert into teams(name) values('$OPPONENT')")
      if [[ $INSERT_RESULT == "INSERT 0 1" ]]; then
        echo "Inserted into teams, $OPPONENT"
      fi
    fi
  fi
done

echo -e "\n~~ Populating games table ~~"

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS; do
  if [[ $YEAR != year ]]; then
    WINNER_ID=$($PSQL "select team_id from teams where name='$WINNER'")
    OPPONENT_ID=$($PSQL "select team_id from teams where name='$OPPONENT'")
    FOUND=$($PSQL "select count(*) from games where year=$YEAR and round='$ROUND' and winner_id=$WINNER_ID and opponent_id=$OPPONENT_ID and winner_goals=$WINNER_GOALS and opponent_goals=$OPPONENT_GOALS")
    if [[ "$FOUND" == 0 ]]; then
      INSERT_RESULT=$($PSQL "insert into games(year,round,winner_goals,opponent_goals,winner_id,opponent_id) values($YEAR,'$ROUND',$WINNER_GOALS,$OPPONENT_GOALS,$WINNER_ID,$OPPONENT_ID)")
      if [[ $INSERT_RESULT == "INSERT 0 1" ]]; then
        echo "Inserting into games, $YEAR,$ROUND,$WINNER_GOALS,$OPPONENT_GOALS,$WINNER_ID,$OPPONENT_ID"
      fi
    fi
  fi
done
