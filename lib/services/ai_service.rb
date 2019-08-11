# frozen_string_literal: true

# Returns a move for the computer, depending on difficulty
class AIService
  attr_accessor :game, :move
  class << self
    def call(game)
      new(game).call
    end
  end

  def initialize(game)
    @game = game
  end

  def call
    @move = if (@game.difficulty == :unbeatable) || ((@game.difficulty == :hard) && (rand < 0.75))
              MinMaxService.call(@game).move
            else
              game.available_moves.sample
            end
    self
  end
end
