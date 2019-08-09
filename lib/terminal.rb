# frozen_string_literal: true

# Responsible for terminal interactions only, using TTY::Prompt
class Terminal
  def run
    prompt = TTY::Prompt.new

    prompt.say "Welcome to Tic-Tac-Toe"

    player = prompt.yes? "Which player do you want to be?" do |q|
      q.default "X"
      q.positive "X"
      q.negative "O"
    end

    move = prompt.ask("Where do you want to move?").upcase

    possible_moves = %w[A1 A2 A3 B1 B2 B3 C1 C2 C3]

    prompt.suggest(move.chars.first, possible_moves, indent: 2)

    prompt.ok "Green!"
    prompt.error "Red!"
  end
end
