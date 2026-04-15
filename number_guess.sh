#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

# Random integer between 1-1000
NUMBER=$(( RANDOM % 1000 + 1 ))

# Get username as input
echo "Enter your username:"
read USERNAME

# query user_id
USER_ID=$($PSQL "SELECT user_id FROM users WHERE username = '$USERNAME'")

# no USER_ID -> new user
if [[ ! $USER_ID ]]
then
  # print welcome message
  echo Welcome, $USERNAME! It looks like this is your first time here.
  # add user to database (assume safe input)
  INSERT_OUT=$($PSQL "INSERT INTO users(username) VALUES('$USERNAME')")
  # query user_id
  USER_ID=$($PSQL "SELECT user_id FROM users WHERE username = '$USERNAME'")

# USER_ID is not empty -> old user
else
  # query number of games and smallest number of guesses
  DATA=$($PSQL "SELECT COUNT(game_id), MIN(guesses) FROM games WHERE user_id = '$USER_ID'")
  # split data into variables
  IFS='|' read -r GAMES_PLAYED BEST_GAME <<< $DATA
  # print welcome back message
  echo "Welcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."
fi

# ask user to input their guess
echo "Guess the secret number between 1 and 1000:"
read GUESS
