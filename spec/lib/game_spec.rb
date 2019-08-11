# frozen_string_literal: true

describe Game do
  let(:game) { build(:game) }
  let(:in_progress) { build(:game, :in_progress) }
  let(:won) { build(:game, :won) }
  let(:draw) { build(:game, :draw) }

  describe ".index_to_row_column" do
    it "should translate a flat index to a row column index" do
      expect(Game.index_to_row_column(5)).to eq([1, 2])
    end
  end

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
      expect(game.state[1][1]).to eq(nil)
      game.take_turn(1, 1)
      expect(game.state[1][1]).to eq(:x)
    end

    it "should toggle the active player" do
      game.take_turn(1, 1)
      expect(game.active_player).to eq(:o)
    end

    it "should return the game status" do
      expect(game.take_turn(1, 1)).to eq(game.game_status)
    end
  end

  describe "#game_status" do
    it "should return :win if the game's been won" do
      expect(won.game_status).to eq(:win)
    end

    it "should return :draw if the game's been drawn" do
      expect(draw.game_status).to eq(:draw)
    end

    it "should return the active player if the game isn't finished" do
      expect(in_progress.game_status).to eq(:x)
    end
  end

  describe "#over?" do
    it "returns true if @over is true" do
      game.over = true
      expect(game.over?).to be_truthy
    end
  end

  describe "#player_is_active?" do
    it "returns true if active_player is the player" do
      expect(game.player_is_active?).to be_truthy
    end
    it "returns false if active_player is not the player" do
      game.active_player = :o
      expect(game.player_is_active?).to be_falsey
    end
  end

  describe "#player_won?" do
    it "returns true if the winner is the player" do
      expect(won.player_won?).to be_truthy
    end
    it "returns false if active_player is not the player" do
      game.active_player = :o
      expect(game.player_is_active?).to be_falsey
    end
  end

  describe "#computer_player" do
    it "should return the opposite of the player" do
      expect(game.computer_player).to eq(:o)
      game.player = :o
      expect(game.computer_player).to eq(:x)
    end
  end

  describe "#available_indexes" do
    it "should return an array of row / column indexes" do
      idx = game.available_indexes
      expect(idx).to be_an Array
      expect(idx.length).to eq(9)
    end

    it "does not list taken squares" do
      expect(in_progress.available_indexes).not_to include([1, 1])
    end

    it "lists available squares" do
      expect(in_progress.available_indexes).to include([0, 0])
    end

    it "returns an empty array if there are no moves" do
      expect(draw.available_indexes).to eq([])
    end
  end

  describe "#copy" do
    it "returns a deep copy of the game" do
      game.state[0][1] = :x
      copy = game.copy
      game.state[1][1] = :o
      expect(copy.state[0][1]).to eq(:x)
      expect(copy.state[1][1]).to be_nil
    end
  end
end
