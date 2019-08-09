# frozen_string_literal: true

describe Game do
  let(:game) { Game.new }

  it "initializes a game" do
    expect(game).to be_a Game
  end

  it "initializes a game with a game state" do
    expect(game.state).to be_an Array
    expect(game.state.length).to eq(3)
    expect(game.state.first.length).to eq(3)
  end

  context "with a game that hasn't completed" do
    let(:game) { build(:game, :in_progress) }

    it "can take a turn" do
      expect { game.take_turn(0, 0) }.not_to raise_error
    end
  end
end
