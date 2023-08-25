# frozen_string_literal: true

# ConnectFour Class
class ConnectFour
  attr_accessor :board

  def create_board
    Array.new(6) { Array.new(7) }
  end

  def initialize
    @board = create_board
  end

  def show_board
    for row in board 
      for column in row
        print "  #{column} " 
      end
      print "\n"
    end
    puts '  0  1  2  3  4  5  6  ' # The footer of the game
  end
end
