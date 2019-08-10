# frozen_string_literal: true

describe GamePresenter do
  let(:new_game) { GamePresenter.new(build(:game)) }
  let(:in_progress) { GamePresenter.new(build(:game, :in_progress)) }
  let(:won) { GamePresenter.new(build(:game, :won)) }
  let(:draw) { GamePresenter.new(build(:game, :draw)) }

  it "accepts a Game as an initialization argument" do
    expect(new_game.__getobj__).to be_a Game
  end

  describe "#available_moves" do
    it "lists all moves on a new game" do
      expect(new_game.available_moves).to eq(GamePresenter::MOVE_NAMES)
    end

    it "does not list taken squares" do
      expect(in_progress.available_moves).not_to include("B2")
    end

    it "lists available squares" do
      expect(in_progress.available_moves).to include("A1")
    end

    it "returns an empty array if there are no moves" do
      expect(draw.available_moves).to eq([])
    end
  end

  describe "#move_to_index" do
    [["A1", [0, 0]], ["B2", [1, 1]], ["A3", [2, 0]]].each do |(text, idx)|
      it "should convert #{text} into #{idx}" do
        expect(new_game.move_to_index(text)).to eq(idx)
      end
    end
  end

  describe "#take_turn" do
    it "should call #mark on the Game" do
      expect(new_game.__getobj__).to receive(:mark).with(1, 1)
      new_game.take_turn("B2")
    end
  end

  describe "#ai_take_turn" do
    it "should call #take_turn" do
      expect(new_game.__getobj__).to receive(:take_turn)
      new_game.ai_take_turn
    end
  end

  describe "#square_character" do
    it "returns a space if given nil" do
      expect(won.square_character(nil)).to eq(" ")
    end

    it "returns X if given :x" do
      expect(won.square_character(:x)).to eq("X")
    end

    it "returns O if given :o" do
      expect(won.square_character(:o)).to eq("O")
    end
  end

  describe "#state_string" do
    it "returns the state as a flattened array, substituing characters" do
      expect(won.state_string).to be_a Array
      expect(won.state_string.length).to eq(9)
      expect(won.state_string).to include(" ")
      expect(won.state_string).to include("O")
      expect(won.state_string).to include("X")
    end
  end

  describe "#to_s" do
    it "returns a long string" do
      expect(won.to_s.length).to be > 100
    end
  end
end
