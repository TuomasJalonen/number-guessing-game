# Number Guessing Game CLI

A command-line number guessing game written in Bash that uses PostgreSQL to store user statistics.

## 📌 Description

This project is a simple interactive game where the user tries to guess a randomly generated number between 1 and 1000.

The game tracks:
- Number of games played per user
- Best game (fewest guesses)

User data is stored in a PostgreSQL database.

---

## 🚀 How to Play

Run the script:

```bash
./number_guess.sh
```

### Gameplay

1. Enter your username
2. If you're a new user, you'll be welcomed and added to the database
3. If you're a returning user, you'll see your stats
4. Start guessing the number!

### Example

```
Enter your username:
tuomas
Welcome back, tuomas! You have played 3 games, and your best game took 5 guesses.
Guess the secret number between 1 and 1000:
500
It's lower than that, guess again:
250
It's higher than that, guess again:
...
```

---

## 🛠️ Requirements

- Bash
- PostgreSQL (`psql` CLI)
- A running PostgreSQL server

---

## 🗄️ Database Setup

A database dump is included:

```
number_guess.sql
```

### 1. Create the database

```bash
createdb number_guess
```

### 2. Import schema and data

```bash
psql -d number_guess -f number_guess.sql
```

> 💡 If needed, specify your PostgreSQL user:
>
> ```bash
> psql -U <your_username> -d number_guess -f number_guess.sql
> ```

---

## ⚙️ Configuration

The script connects to PostgreSQL using:

```bash
psql --username=freecodecamp --dbname=number_guess
```

If your local setup uses a different user, update this line in `number_guess.sh`:

```bash
PSQL="psql --username=<your_username> --dbname=number_guess -t --no-align -c"
```

---

## 📂 Project Structure

```
.
├── number_guess.sh     # Game script
├── number_guess.sql    # Database schema and data
└── README.md
```

---

## ⚠️ Notes

- The script assumes that user input is safe (no SQL injection protection).
- Input validation ensures guesses are integers.
- Designed for educational purposes, not production use.

---

## 📖 What I Learned

- Writing interactive Bash scripts
- Using loops and input validation
- Generating random numbers in Bash
- Querying and updating PostgreSQL databases
- Persisting user data and statistics
- Handling query results in Bash

