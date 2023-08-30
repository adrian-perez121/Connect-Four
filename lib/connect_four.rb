# frozen_string_literal: true

# ConnectFour Class
class ConnectFour
  attr_accessor :board

  def create_board
    Array.new(6) { Array.new(7, ' ') }
  end

  def out_bounds_message
    puts 'You are out of bounds'
  end

  def initialize
    @board = create_board
    @game_over = false
  end

  def show_board
    for row in board 
      for column in row
        print " #{column} " 
      end
      print "\n"
    end
    puts ' 0  1  2  3  4  5  6 ' # The footer of the game
  end

  def add_full(column)
    row = 5
    square = board[row][column]
    until square == ' '
      row -= 1
      break out_bounds_message if row == -1

      square = board[row][column]
    end
    board[row][column] = '♦'
  end

  def add_empty(column)
    row = 5
    square = board[row][column]
    until square == ' '
      row -= 1
      break out_bounds_message if row == -1

      square = board[row][column]
    end
    board[row][column] = '♢'
  end

  def check_horizontal_streak(row, column, symbol, prev_column = nil)
    square = board[row][column]
    # Base Case
    return 0 if square != symbol

    left = column != 0 && prev_column != column - 1 ? check_horizontal_streak(row, column - 1, symbol, column) : 0
    right = column != 6 && prev_column != column + 1 ? check_horizontal_streak(row, column + 1, symbol, column) : 0

    total_streak = left + right + 1

    total_streak
  end

  def check_vertical_streak(row, column, symbol)
    square = board[row][column]
    # Base Case
    return 0 if square != symbol

    bottom = row != 5 ? check_vertical_streak(row + 1, column, symbol) : 0

    total_streak = bottom + 1
    total_streak
  end

  def check_diagonal_streak_up(row, column, symbol, prev_column = nil)
    square = board[row][column]

    return 0 if square != symbol

    diag_backward = column != 0 && row != 5 && prev_column != column - 1 ? check_diagonal_streak_up(row + 1, column - 1, symbol, column) : 0 
    diag_forward = column != 6 && row != 0 && prev_column != column + 1 ? check_diagonal_streak_up(row - 1, column + 1, symbol, column) : 0

    total_streak = diag_backward + diag_forward + 1
    total_streak
  end

  def check_diagonal_streak_down(row, column, symbol, prev_column = nil)
    square = board[row][column]

    return 0 if square != symbol

    diag_forward = column != 6 && row != 5 && prev_column != column + 1 ? check_diagonal_streak_down(row + 1, column + 1, symbol, column) : 0
    diag_backward = column != 0 && row != 0 && prev_column != column - 1 ? check_diagonal_streak_down(row - 1, column - 1 , symbol, column) : 0 

    total_streak = diag_backward + diag_forward + 1
    total_streak
  end

  def four_in_row?(row, column, symbol)
    check_vertical_streak(row, column, symbol) >= 4 || check_horizontal_streak(row, column, symbol) >= 4 || check_diagonal_streak_down(row, column, symbol) >= 4 || check_diagonal_streak_up(row, column, symbol) >= 4
  end

  def play_winner_message(symbol)
    puts "Congratulations, #{symbol} has won the game"
  end

  def play_tie_message
    puts 'Unfortunately, no one won this game'
  end
end
