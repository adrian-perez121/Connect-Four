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
      subject(:game_black) { described_class.new }
      let(:column) { 5 }
      let(:row) { 5 }
      it 'symbol reaches the bottom' do
        game_black.add_full(5)
        square = game_black.board[row][column]
        expect(square).to eq('♦')
      end
    end

    context 'when there is already a symbol occupying a square' do
      subject(:game_black) { described_class.new }
      let(:column) { 5 }
      let(:row) { 4 }
      before do
        game_black.add_full(5)
      end
      it 'the symbol falls on top of the square being occupied' do
        game_black.add_full(5)
        square = game_black.board[row][column]
        expect(square).to eq('♦')
      end
    end
  

    context 'when there is no room left to add the symbol' do
      subject(:game_black) { described_class.new }
      before do
        # To fill up the column (assuming previous tests pass)
        6.times { game_black.add_full(5) }
      end
      it '#out_bounds_message is called' do
        expect(game_black).to receive(:out_bounds_message).once
        game_black.add_full(5)
      end
    end
  end

  describe '#add_empty' do
    # Similar to the test for add_full
    context 'when there is nothing on the bottom of the board' do
      subject(:game_white) { described_class.new }
      let(:column) { 3 }
      let(:row) { 5 }
      it 'reaches the bottom' do
        game_white.add_empty(3)
        square = game_white.board[row][column]
        expect(square).to eq('♢')
      end
    end

    context 'when there is already a symbol occupying a square' do
      subject(:game_white) { described_class.new }
      let(:column) { 3 }
      let(:row) { 4 }
      before do
        game_white.add_empty(3)
      end

      it 'symbol falls on top of the square being occupied' do
        game_white.add_empty(3)
        square = game_white.board[row][column]
        expect(square).to eq('♢')
      end
    end

    context 'when there is no room left to add the symbol' do
      subject(:game_white) { described_class.new }
      before do
        # To fill up the column (assuming previous tests pass)
        6.times { game_white.add_empty(3) }
      end

      it '#out_of_bounds message is called' do
        expect(game_white).to receive(:out_bounds_message).once
        game_white.add_empty(3)
      end
    end
  end

  describe '#check_horizontal_streak' do
    context 'when there is three ♦ in a row and called from the end' do
      # End would mean the ♦ placed farthest to the right

      subject(:game_streak) { described_class.new }
      let(:row) { 5 }
      let(:column) { 2 }
      let(:symbol) { '♦' }
      before do
        game_streak.add_full(0)
        game_streak.add_full(1)
        game_streak.add_full(2)
      end

      it 'returns 3' do
        expect(game_streak.check_horizontal_streak(row, column, symbol)).to eq(3)
      end
    end

    context 'when there is four ♦ in a row and called from the middle' do
      subject(:game_streak) { described_class.new }
      let(:row) { 5 }
      let(:column) { 1 }
      let(:symbol) { '♦' }
      before do
        game_streak.add_full(0)
        game_streak.add_full(1)
        game_streak.add_full(2)
        game_streak.add_full(3)
      end
      it 'returns 4' do
        expect(game_streak.check_horizontal_streak(row, column, symbol)).to eq(4)
      end
    end

    context 'when there is five ♦ in a row and called from the beginning of the board' do
      # Beginning of the board is (5, 0)
      subject(:game_streak) { described_class.new }
      let(:row) { 5 }
      let(:column) { 0 }
      let(:symbol) { '♦' }
      before do
        game_streak.add_full(0)
        game_streak.add_full(1)
        game_streak.add_full(2)
        game_streak.add_full(3)
        game_streak.add_full(4)
      end
      it 'returns 5' do
        expect(game_streak.check_horizontal_streak(row, column, symbol)).to eq(5)
      end
    end
    context 'when there is three ♦ and one ♢ in a row' do
      subject(:game_streak) { described_class.new }
      let(:row) { 5 }
      let(:column) { 2 }
      let(:symbol) { '♦' }
      before do
        game_streak.add_full(0)
        game_streak.add_full(1)
        game_streak.add_full(2)
        game_streak.add_empty(3)
      end
      it 'returns 3' do
        expect(game_streak.check_horizontal_streak(row, column, symbol)).to eq(3)
      end
    end
  end

  describe '#check_vertical_streak' do
    # We are always going to be calling from the highest when checking vertically 
    let(:symbol) { '♦' }
    context 'when there is four ♦ in a column' do
      subject(:game_streak) { described_class.new }
      let(:row) { 2 }
      let(:column) { 0 }
      before do
        4.times { game_streak.add_full(0) }
      end

      it 'returns 4' do
        expect(game_streak.check_vertical_streak(row, column, symbol)).to eq(4)
      end
    end

    context 'when there are three ♦ and two ♢ under in a column' do
      subject(:game_streak) { described_class.new }
      let(:row) { 1 }
      let(:column) { 0 }
      before do
        2.times { game_streak.add_empty(0) }
        3.times { game_streak.add_full(0) }
      end
      it 'returns 3' do
        expect(game_streak.check_vertical_streak(row, column, symbol)).to eq(3)
      end
    end

    context 'when ehere is one ♦ in a column' do
      subject(:game_streak) { described_class.new }
      let(:row) { 5 }
      let(:column) { 0 }
      before { game_streak.add_full(0) }

      it 'returns 1' do
        expect(game_streak.check_vertical_streak(row, column, symbol)).to eq(1)
      end
    end
  end

  # For diaganol cases there is going to have to be two checks the symbols going up and down
  describe '#check_diagonal_streak_up' do
    context 'when there are four ♦ going up diagonaly' do
      subject(:game_diagonal) { described_class.new }
      let(:symbol) { '♦' }
      before do
        game_diagonal.add_full(0)
        game_diagonal.add_empty(1)
        game_diagonal.add_full(1)
        2.times { game_diagonal.add_empty(2) }
        game_diagonal.add_full(2)
        3.times { game_diagonal.add_empty(3) }
        game_diagonal.add_full(3)
      end

      context 'and called in the beginning' do
        let(:row) { 5 }
        let(:column) { 0 }

        it 'returns 4' do
          expect(game_diagonal.check_diagonal_streak_up(row, column, symbol)).to eq(4)
        end
      end

      context 'and called in the middle' do
        let(:row) { 4 }
        let(:column) { 1 }

        it 'returns 4' do
          expect(game_diagonal.check_diagonal_streak_up(row, column, symbol)).to eq(4)
        end
      end

      context 'and called in the end' do
        # End here is the ♦ farthest to the right
        let(:row) { 2 }
        let(:column) { 3 }

        it 'returns 4' do
          expect(game_diagonal.check_diagonal_streak_up(row, column, symbol)).to eq(4)
        end
      end

      context 'when there are three ♦ going up diagnoal and one ♢ at the end' do
        subject(:game_diagonal_three) { described_class.new }
        let(:symbol) { '♦' }
        let(:row) { 5 }
        let(:column) { 0 }

        before do
          game_diagonal_three.add_full(0)
          game_diagonal_three.add_empty(1)
          game_diagonal_three.add_full(1)
          2.times { game_diagonal_three.add_empty(2) }
          game_diagonal_three.add_full(2)
          3.times { game_diagonal_three.add_empty(3) }
          game_diagonal_three.add_empty(3)
        end

        it 'returns 3' do
          expect(game_diagonal_three.check_diagonal_streak_up(row, column, symbol)).to eq(3)
        end
      end
    end
  end

  describe '#check_diaganol_streak_down' do
    context 'when there are four ♦ going down diagonaly' do
      subject(:game_diagonal_four) { described_class.new }
      let(:symbol) { '♦' }

      before do
        game_diagonal_four.board[2][0] = '♦'
        game_diagonal_four.board[3][1] = '♦'
        game_diagonal_four.board[4][2] = '♦'
        game_diagonal_four.board[5][3] = '♦'
      end

      context 'and called from the beginning' do
        let(:row) { 2 }
        let(:column) { 0 }

        xit 'returns 4' do
          expect(game_diagonal_four.check_diaganol_streak_down(row, column, symbol)).to eq(4)
        end
      end

      context 'and called form the middle' do
        let(:row) { 3 }
        let(:column) { 1 }

        xit 'returns 4' do
          expect(game_diagonal_four.check_diaganol_streak_down(row, column, symbol)).to eq(4)
        end
      end

      context 'and called from the end' do
        let(:row) { 5 }
        let(:column) { 3 }

        xit 'returns 4' do
          expect(game_diagonal_four.check_diaganol_streak_down(row, column, symbol)).to eq(4)
        end
      end
    end

    context 'where there are three ♦ and one ♢ at the end' do
      subject(:game_diagonal_three) { described_class.new }
      let(:symbol) { '♦' }
      let(:row) { 2 }
      let(:column) { 0 }
      before do
        game_diagonal_three.board[2][0] = '♦'
        game_diagonal_three.board[3][1] = '♦'
        game_diagonal_three.board[4][2] = '♦'
        game_diagonal_three.board[5][3] = '♢'
      end

      xit 'returns 3' do
        expect(game_diagonal_three.check_diaganol_streak_down(row, column, symbol)).to eq(3)
      end
    end
  end
end
