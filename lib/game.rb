# frozen_string_literal: true

# Contains the state and logic for a Tic-Tac-Toe game.
class Game
  attr_accessor :state, :active_player

  def initialize
    @state = Array.new(3) { Array.new(3) }
    @active_player = :x
  end

  def take_turn(col, row)
    mark(col, row)
    check_for_win || toggle_active
  end

  private

  def mark(col, row)
    @state[col][row] = @active_player
  end

  def check_for_win
    false # TODO
  end

  def toggle_active
    @active_player = @active_player == :x ? :o : :x
  end
end
