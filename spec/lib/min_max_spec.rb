# frozen_string_literal: true

describe MinMax do
  let(:game) { build(:game) }
  let(:nearly_won) { build(:game, :nearly_won) }
  let(:won) { build(:game, :won) }

  describe ".min_max" do
    it "returns nil move if the game is over" do
      expect(MinMax.min_max(won)[:move]).to be_nil
    end

    it "recursively calls itself for each available move" do
      nearly_won.player = :o
      # Simplify the available moves
      expect(nearly_won).to receive(:available_moves).and_return([[1, 1]])
      expect(MinMax.min_max(nearly_won)[:move]).to eq([1, 1])
    end
  end

  describe ".choose_score" do
    let(:min_score) { { score: -1, move: [0, 0] } }
    let(:max_score) { { score: 1, move: [1, 1] } }

    it "returns the max score if the active player is the computer" do
      nearly_won.player = :o
      expect(MinMax.choose_score(nearly_won, [min_score, max_score])).to eq(max_score)
    end

    it "returns the min score if the active player is the player" do
      expect(MinMax.choose_score(nearly_won, [min_score, max_score])).to eq(min_score)
    end
  end

  describe ".score" do
    it "returns 0 if there's no winner" do
      expect(MinMax.score(game)).to eq(0)
    end

    it "returns 1 if the player lost" do
      won.player = :o
      expect(MinMax.score(won)).to eq(1)
    end

    it "returns -1 if the player won" do
      expect(MinMax.score(won)).to eq(-1)
    end
  end
end
