#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

echo $($PSQL "TRUNCATE teams, games")

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  # WINNER
  if [[ $WINNER != "winner" ]]
  then
    # get winner_id
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    # if winner_id not found
    if [[ -z $WINNER_ID ]]
    then
      # insert winner
      INSERT_WINNER=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
      if [[ $INSERT_WINNER == "INSERT 0 1" ]]
      then
        echo "The team $WINNER was inserted into teams."
      fi
    fi
  fi

  # OPPONENT
  if [[ $OPPONENT != "opponent" ]]
  then
    # get opponent_id
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
    # if opponent_id not found
    if [[ -z $OPPONENT_ID ]]
    then
      # insert opponent name
      INSERT_OPPONENT=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
      if [[ $INSERT_OPPONENT == "INSERT 0 1" ]]
      then
        echo "The team $OPPONENT was inserted into teams."
      fi
    fi
  fi

  # INSERT MATCHES
  if [[ $YEAR != "year" && $ROUND != "round" && $WINNER != "winner" && $OPPONENT != "opponent" && $WINNER_GOALS != "winner_goal" && $OPPONENT_GOALS != "opponent_goals" ]]
  then
    # get team_id for winner and opponent
    TEAM_ID_WINNER=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    TEAM_ID_OPPONENT=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
    # insert match
    INSERT_MATCH=$($PSQL "INSERT INTO games(year, round, winner_goals, opponent_goals, winner_id, opponent_id) VALUES($YEAR, '$ROUND', $WINNER_GOALS, $OPPONENT_GOALS, $TEAM_ID_WINNER, $TEAM_ID_OPPONENT)")
    if [[ $INSERT_MATCH == "INSERT 0 1" ]]
    then
      echo "The match between $WINNER ($WINNER_GOALS) x ($OPPONENT_GOALS) $OPPONENT was inserted into games."
    fi
  fi
done