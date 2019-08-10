# frozen_string_literal: true

describe Game do
  let(:game) { build(:game) }
  let(:in_progress) { build(:game, :in_progress) }
  let(:won) { build(:game, :won) }
  let(:draw) { build(:game, :draw) }

  it "initializes a game" do
    expect(game).to be_a Game
  end

  it "initializes a game with a game state" do
    expect(game.state).to be_an Array
    expect(game.state.length).to eq(3)
    expect(game.state.first.length).to eq(3)
  end

  describe "#take_turn" do
    it "should mark a square" do
      expect(game).to receive(:mark).with(1, 1)
      game.take_turn(1, 1)
    end

    it "should return :win if the game's been won" do
      expect(won.take_turn(0, 0)).to eq(:win)
    end

    it "should return :draw if the game's been drawn" do
      draw.state[0][0] = nil
      expect(draw.take_turn(0, 0)).to eq(:draw)
    end

    it "should return the next player if the game isn't finished" do
      expect(in_progress.take_turn(0, 0)).to eq(:o)
    end
  end
end
