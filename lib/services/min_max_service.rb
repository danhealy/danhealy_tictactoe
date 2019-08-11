# frozen_string_literal: true

# Calls the min-max algorithm with a Game and returns a move
class MinMaxService
  class << self
    def call(game)
      new(game).call
    end
  end

  attr_accessor :game, :move

  def initialize(game)
    @game = game
  end

  def call
    # Short circuit the AI on the first turn, for performance
    @move = if @game.available_moves.length >= 8
              # Choose a corner or center
              (@game.available_moves & [[0, 0], [2, 0], [0, 2], [2, 2], [1, 1]]).sample
            else
              MinMax.min_max(@game)[:move]
            end
    self
  end
end
