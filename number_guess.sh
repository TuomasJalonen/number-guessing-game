#!/bin/bash

# This is a game where user tries to guess a random number between 1-1000. 

PSQL="psql --dbname=number_guess -t --no-align -c"

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

# ask user to input their guess and set guess counter to 1
echo "Guess the secret number between 1 and 1000:"
read GUESS
NUMBER_OF_GUESSES=1

# repeat while guess is incorrect
while [[ $GUESS -ne $NUMBER ]]
do
  # check if guess is integer and repeat the read until it is
  while [[ ! $GUESS =~ [0-9]+ ]]
  do
    echo "That is not an integer, guess again:"
    read GUESS
  done
  
  # check if the secret number is lower than guess and print result
  if [[ $NUMBER -lt $GUESS ]]
  then
    echo "It's lower than that, guess again:"

  # check if the secret number is greater than guess and print result
  elif [[ $NUMBER -gt $GUESS ]]
  then
    echo "It's higher than that, guess again:"
  fi

  # read another guess and increment guess counter
  read GUESS
  (( ++NUMBER_OF_GUESSES ))
done

# print result and save the game to database
echo "You guessed it in $NUMBER_OF_GUESSES tries. The secret number was $NUMBER. Nice job!"
INSERT_OUT=$($PSQL "INSERT INTO games(user_id, guesses) VALUES('$USER_ID', $NUMBER_OF_GUESSES)")
