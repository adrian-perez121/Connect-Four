# frozen_string_literal: true

require_relative '../lib/connect_four'

describe ConnectFour do
  describe '#create_board' do
    subject(:game_board) { described_class.new }

    it 'creates 6 rows' do
      rows = game_board.create_board.length
      expect(rows).to eql(6)
    end

    it 'creates 7 columns' do
      row = game_board.create_board[0]
      columns = row.length
      expect(columns).to eql(7)
    end
  end

  describe '#add_full' do
    # Three different cases where the black symbol could be added
    # 5th row indicates the bottom of the board
    # 0th row indicates the top of the board

    context 'when there is nothing at the bottom of the board' do
      subject(:game_full) { described_class.new }
      let(:column) { 5 }
      let(:row) { 5 }
      it 'symbol reaches the bottom' do
        game_full.add_full(5)
        square = game_full.board[row][column]
        expect(square).to eq('♦')
      end
    end

    context 'when there is already a symbol occupying a square' do
      subject(:game_full) { described_class.new }
      let(:column) { 5 }
      let(:row) { 4 }
      before do
        game_full.add_full(5)
      end
      it 'the symbol falls on top of the square being occupied' do
        game_full.add_full(5)
        square = game_full.board[row][column]
        expect(square).to eq('♦')
      end
    end
  

    context 'when there is no room left to add the symbol' do
      subject(:game_full) { described_class.new }
      before do
        # To fill up the column (assuming previous tests pass)
        6.times { game_full.add_full(5) }
      end
      it '#out_bounds_message is called' do
        expect(game_full).to receive(:out_bounds_message).once
        game_full.add_full(5)
      end
    end
  end

  describe '#add_empty' do
    # Similar to the test for add_full
    context 'when there is nothing on the bottom of the board' do
      subject(:game_empty) { described_class.new }
      let(:column) { 3 }
      let(:row) { 5 }
      it 'reaches the bottom' do
        game_empty.add_empty(3)
        square = game_empty.board[row][column]
        expect(square).to eq('♢')
      end
    end

    context 'when there is already a symbol occupying a square' do
      subject(:game_empty) { described_class.new }
      let(:column) { 3 }
      let(:row) { 4 }
      before do
        game_empty.add_empty(3)
      end

      it 'symbol falls on top of the square being occupied' do
        game_empty.add_empty(3)
        square = game_empty.board[row][column]
        expect(square).to eq('♢')
      end
    end

    context 'when there is no room left to add the symbol' do
      subject(:game_empty) { described_class.new }
      before do
        # To fill up the column (assuming previous tests pass)
        6.times { game_empty.add_empty(3) }
      end

      it '#out_of_bounds message is called' do
        expect(game_empty).to receive(:out_bounds_message).once
        game_empty.add_empty(3)
      end
    end
  end

  describe '#board_full?' do
    # The board will be full when the top row is filled with symbols
    context 'when the top row is not completely filled' do
      subject(:game_not_full) { described_class.new }
      before do
        game_not_full.board[0] = Array.new(7, '♦')
        game_not_full.board[0][4] = ' '
      end

      it 'returns false' do
        expect(game_not_full.board_full?).to be false
      end

      context 'when the top row is completely filled' do
        subject(:game_full) { described_class.new }
        before do
          game_full.board[0] = Array.new(7, '♦')
        end

        it 'returns true' do
          expect(game_full.board_full?).to be true
        end
      end
    end
  end

  describe '#decide_game_over' do
    let(:dummy_column) { 0 }
    let(:dummy_row) { 5 }
    let(:symbol) { '♦' }
    context 'when there is a four in a row' do
      subject(:game_win) { described_class.new }
      before do
        allow(game_win).to receive(:four_in_row?).and_return(true)
        allow(game_win).to receive(:board_full?).and_return(false)
      end
      it 'calls the #play_winner_message and does not call #play_tie_message' do
        expect(game_win).to receive(:play_winner_message)
        expect(game_win).not_to receive(:play_tie_message)
        game_win.decide_game_over(dummy_row, dummy_column, symbol)
      end

      it '@game_over to be true' do
        game_win.decide_game_over(dummy_row, dummy_column, symbol)
        expect(game_win.game_over).to be true
      end
    end

    context 'when there is a tie' do
      subject(:game_tie) { described_class.new }
      before do
        allow(game_tie).to receive(:four_in_row?).and_return(false)
        allow(game_tie).to receive(:board_full?).and_return(true)
      end
      it 'does not call #play_winner_message and calls #play_tie_message' do
        expect(game_tie).not_to receive(:play_winner_message)
        expect(game_tie).to receive(:play_tie_message)
        game_tie.decide_game_over(dummy_row, dummy_column, symbol)
      end

      it '@game_over to be true' do
        game_tie.decide_game_over(dummy_row, dummy_column, symbol)
        expect(game_tie.game_over).to be true
      end
    end

    context 'when there is both' do
      subject(:game_both) { described_class.new }
      before do
        allow(game_both).to receive(:four_in_row?).and_return(true)
        allow(game_both).to receive(:board_full?).and_return(true)
      end
      it 'only calls on #play_winner_message' do
        expect(game_both).to receive(:play_winner_message)
        expect(game_both).not_to receive(:play_tie_message)
        game_both.decide_game_over(dummy_row, dummy_column, symbol)
      end

      it '@game_over to be true' do
        game_both.decide_game_over(dummy_row, dummy_column, symbol)
        expect(game_both.game_over).to be true
      end
    end

    context 'when there is neither' do
      subject(:game_none) { described_class.new }
      before do
        allow(game_none).to receive(:four_in_row?).and_return(false)
        allow(game_none).to receive(:board_full?).and_return(false)
      end

      it 'does not call any method' do
        expect(game_none).not_to receive(:play_winner_message)
        expect(game_none).not_to receive(:play_tie_message)
        game_none.decide_game_over(dummy_row, dummy_column, symbol)
      end

      it '@game_over to be false' do
        game_none.decide_game_over(dummy_row, dummy_column, symbol)
        expect(game_none.game_over).to be false
      end
    end
  end
end
