# frozen_string_literal: true

# Contains the state and logic for a Tic-Tac-Toe game.
class Game
  attr_accessor :state, :active_player

  WIN_CONDITIONS = %i[x o].map { |i| [i].cycle(3).to_a }.freeze

  def initialize
    @state = Array.new(3) { Array.new(3) }
    @active_player = :x
  end

  # Marks a square and returns game status: win, draw, or next player
  def take_turn(col, row)
    mark(col, row)
    if check_for_win
      :win
    elsif check_for_draw
      :draw
    else
      toggle_active
    end
  end

  private

  def mark(col, row)
    @state[col][row] = @active_player
  end

  # Returns the state as an array of possible winning square combinations
  def win_combinations
    diagonals = (0..2).map { |i| [state[i][i], state[2 - i][i]] }.transpose
    (diagonals + state + state.transpose)
  end

  def check_for_win
    win_combinations.find do |ary|
      WIN_CONDITIONS.include? ary
    end
  end

  # Expect check_for_win to run prior to this
  def check_for_draw
    state.flatten.compact.length == 9
  end

  def toggle_active
    @active_player = @active_player == :x ? :o : :x
  end
end
