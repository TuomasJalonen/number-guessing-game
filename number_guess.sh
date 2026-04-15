#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

NUMBER=$(( RANDOM % 1000 + 1 ))

echo "Enter your username:"
read USERNAME

# query number of games and smallest number of guesses
DATA=$($PSQL "SELECT COUNT(game_id), MIN(guesses) FROM games RIGHT JOIN users ON games.user_id = users.user_id WHERE username = '$USERNAME'")

# no data -> new user
if [[ -z $DATA ]]
then
  # print welcome message
  echo Welcome, $USERNAME! It looks like this is your first time here.
  # add user to database (assume safe input)
  INSERT_OUT=$($PSQL "INSERT INTO users(username) VALUES('$USERNAME')")
  
# data exists -> old user
else
  # split data into variables
  IFS='|' read -r GAMES_PLAYED BEST_GAME <<< $DATA
  # print welcome back message
  echo "Welcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."
fi

echo "Guess the secret number between 1 and 1000:"
read GUESS

echo "
