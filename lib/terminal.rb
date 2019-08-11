# frozen_string_literal: true

# Responsible for terminal interactions only, using TTY::Prompt
class Terminal
  attr_accessor :prompt, :cur_game

  def initialize
    @prompt = TTY::Prompt.new
  end

  def run
    @prompt.say "Welcome to Tic-Tac-Toe"
    new_game
    @prompt.say "Thanks for playing."
  end

  def new_game
    loop do
      player = choose_player
      difficulty = choose_difficulty

      @cur_game = GamePresenter.new(Game.new(player, difficulty))
      ai_take_turn if player == :o
      play_game

      break unless @prompt.yes? "Play again?"
    end
  end

  def choose_player
    player = @prompt.yes? "Which player do you want to be?" do |q|
      q.default "X"
      q.suffix "X/o"
    end

    player = player ? :x : :o

    @prompt.say "You're player #{player.to_s.upcase}."
    player
  end

  def choose_difficulty
    @prompt.select("Choose your difficulty:",
                   Game::DIFFICULTIES.map(&:to_s).map(&:capitalize)).downcase.to_sym
  end

  def play_game
    loop do
      @prompt.say @cur_game.to_s

      return if check_result(@cur_game.take_turn_by_name(select_move))
      return if check_result(ai_take_turn)
    end
  end

  def select_move
    moves = @cur_game.available_move_names
    marked = nil
    until moves.include? marked
      marked = @prompt.ask("Which square do you want to mark?").upcase
      break if moves.include? marked

      suggest_moves(marked, moves)
    end
    marked
  end

  def suggest_moves(marked, moves)
    first_char = marked.chars.first
    if %w[A B C].include? first_char
      @prompt.suggest(marked, moves, indent: 2)
    else
      @prompt.say "Available moves: #{moves.join(' ')}"
    end
  end

  def check_result(move) # rubocop:disable Metrics/MethodLength
    @prompt.say @cur_game.to_s if @cur_game.over?
    case move
    when :win
      if @cur_game.player_won?
        @prompt.ok "You've won!"
      else
        @prompt.error "The computer wins!"
      end
    when :draw
      @prompt.warn "The game is a draw!"
    end
    @cur_game.over?
  end

  def ai_take_turn
    @cur_game.take_turn(*AIService.call(@cur_game).move)
  end
end
