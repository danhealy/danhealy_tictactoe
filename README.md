# Description

  This code was developed in August 2019 by Dan Healy as a code sample.

  This is an implementation of the game [Tic-Tac-Toe](https://en.wikipedia.org/wiki/Tic-tac-toe), where the players will take turns marking spaces in a 3 by 3 grid.  A player wins by placing three marks in a line; either horizontally, vertically or diagonally.  The human player may choose to go first (as X's) or second (as O's), and the computer will play the opposite role.  The human player then chooses the computer's skill level:

  - Easy: Random selections
  - Hard: Optimal selection 75% of the time
  - Unbeatable: Optimal selection always


## Usage

To run, make sure you have the required Ruby version 2.6.3 installed.

Then, run `bundle install`

Finally, run `ruby tictactoe.rb`


You'll be asked to choose a player, select a difficulty, and then you'll take turns against an AI opponent.  When the game ends, it will announce whether or not you've won, and ask if you'd like to play again.  Typing `N` at this point, or typing `Ctrl-C` at any point, will end the session.

## Implementation details

Uses [tty-prompt](https://github.com/piotrmurach/tty-prompt) gem for terminal interaction.

Run tests using `rspec`

Rubocop is available: `rubocop`

Test coverage is available:
```
$ rspec
$ open coverage/index.html
```

### Structure

The `Terminal` class controls all interaction with the human player.  The `Game` class contains all game logic.  The `GamePresenter` class implements a presenter pattern for the `Game` which handles text-based output for the `Terminal`. `AIService` and `MinMaxService` are service objects that expect a `Game` as an input and return a move for the computer, contingent on the game's difficulty.

### AI

I've implemented the [MinMax algorithm](https://www.geeksforgeeks.org/minimax-algorithm-in-game-theory-set-3-tic-tac-toe-ai-finding-optimal-move/).  During implementation of this algorithm, I had to refactor the Game class significantly to support introspection and deep copying.

Essentially, the algorithm will create a copy of the game board for each available move, take the move and then call itself with the copy.  The move is evaluated by a score: 1 if it results in the computer winning, -1 if it results in the player winning, 0 for a draw or incomplete game.  At each depth, a maximum score for the active player at that depth is chosen and returned.  This includes the first depth of analysis, and therefore the computer selects an immediate move which optimizes it's eventual score.
