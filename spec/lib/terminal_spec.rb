# frozen_string_literal: true

describe Terminal do
  let(:tty) { TTY::TestPrompt.new }
  let(:terminal) { Terminal.new(tty) }
  let(:game) { GamePresenter.new(build(:game)) }
  let(:in_progress) { GamePresenter.new(build(:game, :in_progress)) }
  let(:won) { GamePresenter.new(build(:game, :won)) }
  let(:draw) { GamePresenter.new(build(:game, :draw)) }
  let(:moves) { %w[A1 B2 C3] }

  before do
    terminal.cur_game = game
  end

  describe "#run" do
    it "should welcome the user" do
      allow(terminal).to receive(:new_game)
      terminal.run
      expect(tty.output.string).to include("Welcome")
    end

    it "should begin a new game" do
      expect(terminal).to receive(:new_game)
      terminal.run
    end
  end

  describe "#new_game" do
    it "should create a new game" do
      expect(terminal).to receive(:choose_player).and_return(:x)
      expect(terminal).to receive(:choose_difficulty).and_return(:easy)
      expect(Game).to receive(:new).with(:x, :easy).and_return(game)
      expect(terminal).to receive(:play_game)
      expect(tty).to receive(:yes?).and_return(false)
      terminal.new_game
    end
  end

  describe "#choose_player" do
    it "should ask the user to choose a side and return it as a symbol" do
      expect(tty).to receive(:yes?).and_return(true)
      expect(terminal.choose_player).to eq(:x)
    end

    it "should present X and O as options" do
      tty.input << "X"
      tty.input.rewind
      expect(terminal.choose_player).to eq(:x)
      expect(tty.output.string).to include("X/o")
    end
  end

  describe "#choose_difficulty" do
    it "should ask the user to choose difficulty and return it as a symbol" do
      expect(tty).to receive(:select).and_return("Easy")
      expect(terminal.choose_difficulty).to eq(:easy)
    end
  end

  describe "#play_game" do
    it "should print the game board" do
      expect(terminal).to receive(:select_move).and_return("A1")
      expect(terminal).to receive(:check_result).and_return(true)
      terminal.play_game
      expect(tty.output.string).to include("+---+")
    end

    it "should let the AI take a turn" do
      expect(terminal).to receive(:select_move).and_return("A1")
      expect(terminal).to receive(:check_result).once.and_return(false)
      expect(terminal).to receive(:check_result).once.and_return(true)
      terminal.play_game
      expect(tty.output.string).to include("+---+")
    end
  end

  describe "#select_move" do
    before do
      expect(game).to receive(:available_move_names).and_return(moves)
    end

    it "should return a valid move" do
      tty.input << "A1"
      tty.input.rewind
      expect(terminal.select_move).to eq("A1")
    end

    it "should suggest moves if given an invalid response" do
      tty.input << "XYZ\rB2"
      tty.input.rewind
      expect(terminal).to receive(:suggest_moves)
      expect(terminal.select_move).to eq("B2")
    end
  end

  describe "#suggest_moves" do
    it "should show all moves if what's marked doesn't make any sense" do
      terminal.suggest_moves("xyz", moves)
      expect(tty.output.string).to include("Available moves")
    end

    it "should show a subset of moves if the first letter matches" do
      terminal.suggest_moves("A2", moves)
      expect(tty.output.string).to include("Did you mean")
    end
  end

  describe "#check_result" do
    context "with a finished game" do
      before do
        terminal.cur_game = won
        terminal.check_result(:win)
      end

      it "should print the game board" do
        expect(tty.output.string).to include("+---+")
      end

      it "should say something about the game" do
        expect(tty.output.string).to include("You've won!")
      end

      it "should return true" do
        expect(terminal.check_result(:win)).to be_truthy
      end
    end
    context "with a lost game" do
      it "should say something about the game" do
        won.player = :o
        terminal.cur_game = won
        terminal.check_result(:win)
        expect(tty.output.string).to include("computer wins!")
      end
    end
    context "with a drawn game" do
      it "should say something about the game" do
        terminal.cur_game = draw
        terminal.check_result(:draw)
        expect(tty.output.string).to include("draw!")
      end
    end
    context "with an unfinished game" do
      before do
        terminal.cur_game = in_progress
      end
      it "should return false" do
        expect(terminal.check_result(:x)).to be_falsey
      end
    end
  end

  describe "#ai_take_turn" do
    it "should call AIService" do
      ai_double = double("AIService")
      expect(AIService).to receive(:call).and_return(ai_double)
      expect(ai_double).to receive(:move).and_return([0, 0])
      terminal.ai_take_turn
    end
  end

end
