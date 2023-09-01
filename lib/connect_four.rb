# frozen_string_literal: true

require_relative '../lib/find_four_in_a_row'

# ConnectFour Class
class ConnectFour
  attr_accessor :board, :game_over, :target_coordinates

  include FindFourInARow

  def create_board
    Array.new(6) { Array.new(7, ' ') }
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

  def out_bounds_message
    puts 'This column is full, try another column.'
  end

  def play_intro_message
    puts 'Hello! Welcome to connect four!'
  end

  def play_winner_message(symbol = nil)
    puts "Congratulations, #{symbol} has won the game"
  end

  def play_tie_message
    puts 'Unfortunately, no one won this game'
  end

  def initialize
    @board = create_board
    @game_over = false
    @target_coordinates = nil
  end

  def play
    play_intro_message
    show_board
    loop do
      player_turn('♦')
      break if game_over && !continue_playing?

      player_turn('♢')
      break if game_over && !continue_playing?
    end
  end

  def player_turn(symbol)
    puts "#{symbol}, it's your turn!"
    add_symbol(player_input, symbol)
    show_board
    decide_game_over(target_coordinates[0], target_coordinates[1], symbol)
  end

  def player_input
    column = -1
    until column.between?(0, 6)
      puts 'Where would you like to put your peice?'
      input = gets.chomp
      next unless input.match(/^[0-6]$/)

      column = input.to_i
    end
    column
  end

  def add_symbol(column, symbol)
    row = 5
    out_bounds_message unless column_empty?(column)
    column = player_input until column_empty?(column)
    square = board[row][column]

    until square == ' '
      row -= 1

      square = board[row][column]
    end
    board[row][column] = symbol
    @target_coordinates = [row, column]
  end

  def board_full?
    board[0].all? { |square| square != ' ' }
  end

  def column_empty?(column)
    board[0][column] == ' '
  end

  def decide_game_over(row, column, symbol)
    # Parameters will need to be passed down for #four_in_row? to be used
    if four_in_row?(row, column, symbol)
      play_winner_message(symbol)
    elsif board_full?
      play_tie_message
    end
    self.game_over = four_in_row?(row, column, symbol) || board_full?
  end

  def continue_playing?
    puts 'Would you like to play again?[y/n]'
    loop do
      answer = gets.chomp
      if answer == 'y'
        @board = create_board
        show_board
        return true
      elsif answer == 'n'
        return false
      else
        puts "Sorry I didn't get that, try again"
      end
    end
  end
end
