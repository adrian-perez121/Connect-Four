# frozen_string_literal: true

# ConnectFour Class
class ConnectFour
  def create_board
    Array.new(6) { Array.new(7) }
  end

  def initialize
    @board = create_board
  end
end
