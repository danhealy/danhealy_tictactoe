# frozen_string_literal: true

# Responsible for terminal interactions only, using TTY::Prompt
class Terminal
  attr_accessor :prompt, :cur_game, :player

  def initialize
    @prompt = TTY::Prompt.new
  end

  def run
    prompt.say "Welcome to Tic-Tac-Toe"

    new_game
  end

  def new_game
    @cur_game = GamePresenter.new(Game.new)

    player = prompt.yes? "Which player do you want to be?" do |q|
      q.default "X"
      q.positive "X"
      q.negative "O"
    end
    player = player ? :x : :o

    prompt.say "You're player #{player.to_s.upcase}."

    play_game
  end

  def play_game
    puts cur_game.to_s
    #prompt.say cur_game.to_s

    marked = prompt.ask("Which square do you want to mark?").upcase

    prompt.suggest(marked.chars.first, cur_game.available_moves, indent: 2)

    prompt.ok "Green!"
    prompt.error "Red!"
  end
end
