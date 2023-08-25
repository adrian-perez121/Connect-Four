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
end
