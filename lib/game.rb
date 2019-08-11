# frozen_string_literal: true

# Contains the state and logic for a Tic-Tac-Toe game.
class Game
  attr_accessor :state, :active_player, :player, :difficulty, :winner, :over

  WIN_CONDITIONS = %i[x o].map { |i| [i].cycle(3).to_a }.freeze

  DIFFICULTIES = %i[easy hard unbeatable].freeze

  # To convert a flattened state index into a row/column index
  def self.index_to_row_column(idx)
    [idx / 3, idx % 3]
  end

  def initialize(player = :x, difficulty = DIFFICULTIES.first)
    @state = Array.new(3) { Array.new(3) }
    @active_player = :x
    @player = player
    @difficulty = difficulty
  end

  # NOTE: For a larger project, I'd consider breaking this out into a service
  # Marks a square and returns game status: win, draw, or next player
  def take_turn(row, col)
    mark(row, col)
    toggle_active
    game_status
  end

  def game_status
    ret = if check_for_win
            :win
          elsif check_for_draw
            :draw
          else
            @active_player
          end
    @over = %i[win draw].include? ret
    ret
  end

  def over?
    @over == true
  end

  def player_is_active?
    @active_player == @player
  end

  def player_won?
    @winner == @player
  end

  def computer_player
    (%i[x o] - [@player]).first
  end

  def available_indexes
    @state.flatten.each_with_object([]).with_index do |(square, result), idx|
      result << Game.index_to_row_column(idx) if square.nil?
    end
  end

  alias available_moves available_indexes

  def copy
    new_game = dup
    new_game.state = @state.map(&:dup)
    new_game
  end

  private

  def mark(row, col)
    @state[row][col] = @active_player
  end

  # Returns the state as an array of possible winning square combinations
  def win_combinations
    diagonals = (0..2).map { |i| [@state[i][i], @state[2 - i][i]] }.transpose
    (diagonals + @state + @state.transpose)
  end

  def check_for_win
    @winner = win_combinations.find do |ary|
      WIN_CONDITIONS.include? ary
    end&.compact&.first
  end

  # Expect check_for_win to run prior to this
  def check_for_draw
    @state.flatten.compact.length == 9
  end

  def toggle_active
    @active_player = @active_player == :x ? :o : :x
  end
end
