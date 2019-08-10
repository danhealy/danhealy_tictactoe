# frozen_string_literal: true

# Presentation logic for a Game
class GamePresenter < SimpleDelegator
  MOVE_NAMES = %w[A1 B1 C1 A2 B2 C2 A3 B3 C3].freeze

  def available_moves
    state.flatten.each_with_object([]).with_index do |(square, result), idx|
      result << MOVE_NAMES[idx] if square.nil?
    end
  end

  # Converts text move into state index (e.g. 'B2' -> [1,1])
  def move_to_index(move)
    flattened_index = MOVE_NAMES.index(move)
    [flattened_index / 3, flattened_index % 3]
  end

  # A convenience to call take_turn using the text move syntax
  def take_turn(move)
    super(*move_to_index(move))
  end

  # Provides character substitution for expected square values :x, :o and nil
  def square_character(square_val)
    case square_val
    when :x, :o
      square_val.to_s.upcase
    else
      " "
    end
  end

  # Returns the state as a flattened array, substituing characters
  def state_string
    state.flatten.each_with_object([]) do |square, result|
      result << square_character(square)
    end
  end

  # Returns a string representing the entire game board
  def to_s
    separator = "  +---+---+---+\n"
    string = "    A   B   C  \n" + separator
    state_string.each_slice(3).with_index do |row, idx|
      string += "#{idx + 1} + " + row.join(" + ") + " +\n" + separator
    end
    string
  end
end
