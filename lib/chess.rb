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

  def play_round
    # Show board on each round
    show_board
    # Get piece and move from user
    piece, move = select_piece_and_move
    # Update Board
    update_board(piece, move)
    # Check if move initiated check
    # check_message if @current_player == @player_one ? @player_two.king.in_check? : @player_one.king_in_check?
    # Check for stalemate
  end

  def update_board(piece, move)
    # Update Board
    @board[move[0]][move[1]] = piece
    # Reset Board at piece pos to nil
    @board[piece.pos[0]][piece.pos[1]] = nil
    # Update Piece Pos
    piece.pos = move
  end

  def select_piece_and_move
    piece = player_select_piece
    [piece, player_input_move(piece)]
  end

  def player_select_piece
  end

  # Maybe Change to a dictionary mapping algebraic notation to array indexes!
  def player_input_move(piece)
    move = gets.chomp.split(',').map(&:to_i)
    move = player_input_move(piece) unless valid_move(piece, move)
    move
  end

  def valid_move(piece, move)
    return false if move.length != 2
    return false unless (0..7).include?(move[0])
    return false unless (0..7).include?(move[1])
    return false unless piece.moves.include?(move)

    # Make sure move is in piece's available moves!

    true
  end

  def check_message
    if @current_player == @player_one
      puts "#{@player_two.capitalize} king is in check!"
    else
      puts "#{@player_one.capitalize} king is in check!"
    end
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
