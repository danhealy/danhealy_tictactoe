# Description

  This is an implementation of the game [Tic-Tac-Toe](https://en.wikipedia.org/wiki/Tic-tac-toe), where the players will take turns marking spaces in a 3 by 3 grid.  A player wins by placing three marks in a line; either horizontally, vertically or diagonally.  The human player may choose to go first (as X's) or second (as O's), and the computer will play the opposite role.


## Usage

To run, make sure you have the required Ruby version 2.6.3 installed.

Then, run `bundle install`

Finally, run `ruby tictactoe.rb`


You'll be asked to choose a player, and then you'll take turns against a random AI opponent.  When the game ends, it will announce whether or not you've won, and ask if you'd like to play again.  Saying `N` at this point, or typing `Ctrl-C` at any point, will end the session.

## Implementation details

Uses [tty-prompt](https://github.com/piotrmurach/tty-prompt) gem for terminal interaction.

Run tests using `rspec`

Rubocop is available: `rubocop`

Test coverage is available:
```
$ rspec
$ open coverage/index.html
```

TODO: I still need to implement tests for the Terminal class, and possibly implement a better AI opponent.

***

Dan Healy, 2019
