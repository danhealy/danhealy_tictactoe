# frozen_string_literal: true

# Implementation of the MinMax algorithm
# Could potentially be used for other games so long as the input Game object implements:
# #copy, #available_moves, #take_turn, #active_player, #computer_player, #winner
class MinMax
  class << self
    def min_max(game)
      return { score: score(game), move: nil } if game.over?

      scores = []

      # For each possible move,
      game.available_moves.each do |move|
        # Create a copy of the game state
        possible_game = game.copy
        # Take the possible move in the copy
        possible_game.take_turn(*move)
        # Recursively call min_max on the copy and return the resulting score
        score = min_max(possible_game)[:score]
        scores << { score: score, move: move }
      end

      # Now that we have scores for all possible moves,
      # choose the best move for the player being simulated on this turn
      choose_score(game, scores)
    end

    def choose_score(game, scores)
      if game.active_player == game.computer_player
        scores.max_by { |s| s[:score] }
      else
        scores.min_by { |s| s[:score] }
      end
    end

    # Simple scoring where only a win or a loss results in a value other than 0.
    def score(game)
      if game.winner.nil?
        0
      elsif game.winner == game.computer_player
        1
      else
        -1
      end
    end
  end
end
