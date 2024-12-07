require_relative('./../lib/pieces/rook')
require_relative('./../lib/pieces/pawn')
require_relative('./../lib/pieces/bishop')
require_relative('./../lib/pieces/knight')
require_relative('./../lib/pieces/queen')

class Game
  attr_accessor :board

  def initialize
    @player_one = 'white'
    @player_two = 'black'
    @current_player = @player_one
    @winner = nil
    @board = [["\u265C", "\u265E", "\u265D", "\u265B", "\u265A", "\u265D", "\u265E", "\u265C"],
              ["\u265F", "\u265F", "\u265F", "\u265F", "\u265F", "\u265F", "\u265F", "\u265F"],
              [], [], [], [],
              ["\u2659", "\u2659", "\u2659", "\u2659", "\u2659", "\u2659", "\u2659", "\u2659"],
              ["\u2656", "\u2658", "\u2657", "\u2655", "\u2654", "\u2657", "\u2658", "\u2656"]]
  end

  def show_board
    @board.each do |index|
      p index
    end
  end

  def check_message
    puts "#{@current_player.capitalize} king is in check!"
  end

  def change_player
    @current_player = @current_player == @player_one ? @player_two : @player_one
  end

  def check_pawns
    @current_player == @player_one ? pawn_change_white : pawn_change_black
  end

  def pawn_change_white
    @board[0].each_with_index do |piece, index|
      create_new_piece_white(pawn_change, [0, index]) if !piece.nil? && piece.is_a?(WhitePawn)
    end
    nil
  end

  def pawn_change_black
    @board[7].each_with_index do |piece, index|
      create_new_piece_black(pawn_change, [7, index]) if !piece.nil? && piece.is_a?(BlackPawn)
    end
    nil
  end

  def pawn_change
    puts 'What piece would you like? '
    piece = gets.chomp
    piece = pawn_change unless valid_piece(piece)
    piece
  end

  def valid_piece(piece)
    piece = piece.downcase
    %w[rook bishop knight queen].include?(piece)
  end

  def create_new_piece_black(piece, index)
    case piece
    when 'rook'
      @board[index[0]][index[1]] = BlackRook.new([index[0], index[1]], @board)
    when 'bishop'
      @board[index[0]][index[1]] = BlackBishop.new([index[0], index[1]], @board)
    when 'knight'
      @board[index[0]][index[1]] = BlackKnight.new([index[0], index[1]], @board)
    when 'queen'
      @board[index[0]][index[1]] = BlackQueen.new([index[0], index[1]], @board)
    end
  end

  def create_new_piece_white(piece, index)
    case piece
    when 'rook'
      @board[index[0]][index[1]] = WhiteRook.new([index[0], index[1]], @board)
    when 'bishop'
      @board[index[0]][index[1]] = WhiteBishop.new([index[0], index[1]], @board)
    when 'knight'
      @board[index[0]][index[1]] = WhiteKnight.new([index[0], index[1]], @board)
    when 'queen'
      @board[index[0]][index[1]] = WhiteQueen.new([index[0], index[1]], @board)
    end
  end
end
