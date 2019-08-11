# frozen_string_literal: true

describe AIService do
  let(:game) { build(:game, :in_progress) }
  let(:service) { AIService.new(game) }

  describe ".call" do
    it "should instantiate a new service and call it" do
      svc = AIService.call(game)
      expect(svc).to be_a AIService
      expect(svc.move).to_not be nil
    end
  end

  describe "#call" do
    it "should choose randomly if the game difficulty is easy" do
      ary = double("Array")
      expect(game).to receive(:available_moves).and_return(ary)
      expect(ary).to receive(:sample).and_return([0, 0])
      service.call
    end

    it "should sometimes choose randomly if the game difficulty is hard" do
      allow(service).to receive(:rand).and_return(0.99)
      game.difficulty = :hard
      ary = double("Array")
      expect(game).to receive(:available_moves).and_return(ary)
      expect(ary).to receive(:sample).and_return([0, 0])
      service.call
    end

    it "should usually choose intelligently if the game difficulty is hard" do
      allow(service).to receive(:rand).and_return(0.5)
      expect(MinMax).to receive(:min_max).and_return(move: [0, 0])
      game.difficulty = :hard
      service.call
    end

    it "should always choose intelligently if the game difficulty is unbeatable" do
      expect(MinMax).to receive(:min_max).and_return(move: [0, 0])
      game.difficulty = :unbeatable
      service.call
    end
  end
end
