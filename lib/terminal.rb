# frozen_string_literal: true

# Responsible for terminal interactions only, using TTY::Prompt
class Terminal
  attr_accessor :prompt, :cur_game

  def initialize
    @prompt = TTY::Prompt.new
  end

  def run
    prompt.say "Welcome to Tic-Tac-Toe"

    marked = prompt.ask("Which square do you want to mark?").upcase

    prompt.suggest(move.chars.first, possible_moves, indent: 2)

    prompt.ok "Green!"
    prompt.error "Red!"
  end

  def new_game
    @cur_game = GamePresenter.new(Game.new)

    @cur_game.player = prompt.yes? "Which player do you want to be?" do |q|
      q.default "X"
      q.positive "X"
      q.negative "O"
    end
  end
end
