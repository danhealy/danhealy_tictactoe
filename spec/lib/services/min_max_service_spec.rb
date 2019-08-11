# frozen_string_literal: true

describe MinMaxService do
  let(:game) { build(:game) }
  let(:in_progress) { build(:game, :in_progress) }
  let(:ai) { MinMaxService.new(game) }

  describe "#call" do
    it "should return a random first choice if the game is new" do
      expect(MinMax).to_not receive(:min_max)
      ai.call
    end

    it "should call #min_max if the game is in progress" do
      expect(MinMax).to receive(:min_max).and_return(move: [1, 1])
      ai.game = in_progress
      ai.call
    end
  end
end
