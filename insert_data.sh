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
