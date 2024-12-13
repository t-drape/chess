require_relative('./../lib/pieces/rook')
require_relative('./../lib/pieces/pawn')
require_relative('./../lib/pieces/bishop')
require_relative('./../lib/pieces/knight')
require_relative('./../lib/pieces/queen')
require_relative('./player')

class Game
  attr_accessor :board

  def initialize
    @winner = nil
    @player_one = WhitePlayer.new(@board)
    @player_two = BlackPlayer.new(@board)
    @board = [@player_two.non_pawns,
              @player_two.pawns,
              [nil, nil, nil, nil, nil, nil, nil, nil],
              [nil, nil, nil, nil, nil, nil, nil, nil],
              [nil, nil, nil, nil, nil, nil, nil, nil],
              [nil, nil, nil, nil, nil, nil, nil, nil],
              @player_one.pawns,
              @player_one.non_pawns]
    @current_player = @player_one
  end

  def show_board
    @board.each do |index|
      puts index
    end
  end

  def play_game
    start_message
    play_round until @winner || draw?
    end_message(@winner)
  end
  # Maybe calculate current players legal moves,

  # Use moves to determine if checkmate exists
  # All moves = 0 and @current_player.king.in_check?
  # Winner is opponent
  # Use moves to determine if stalemate exists
  # all_moves == 0

  # Helpful site, url: https://www.chessstrategyonline.com/content/tutorials/how-to-play-chess-draws#:~:text=Insufficient%20material,drawn%20due%20to%20insufficient%20material
  # Helpful site, url: https://gamedev.stackexchange.com/questions/194405/in-a-chess-simulator-how-to-efficiently-determine-checkmate

  # End game check
  # Checkmate:
  # @current_player.king.in_check?
  # @current_player.all_moves_lead_to_check
  # end_message(@other_player)
  # Stalemate:
  # @current_player.no_legal_moves
  # end_message(nil)
  # Insufficient material:
  # King vs king with no other pieces.
  # King and bishop vs king.
  # King and knight vs king.
  # @current_player vs @other_player
  # end_message(nil)
  # Voluntary Draw:
  # "Player @current_player wishes to draw: "
  # "Player @other_player,"
  # "Do you also wish to draw? [Y/N]"
  # end_message(nil)

  def end_game_check
    # Checkmate
    #
    # Stalemate
  end

  def play_round
    # Show board on each round
    show_board
    # Get piece and move from user
    piece, move = select_piece_and_move
    # Update Board
    # If current king is in check
    # old_board = @board
    # old_pos = piece.pos
    update_board(piece, move)
    # Move must get King out of check, or keep King out of check

    # UNCOMMENT WHEN PLAYERS ARE MODELED!!!

    # out_of_check(old_board, piece, old_pos)
    # Check if move initiated check
    # check_message if @current_player == @player_one ? @player_two.king.in_check? : @player_one.king_in_check?
    # Update last move of each pawn
  end

  # def out_of_check(old_board, piece, old_pos)
  #   return unless @current_player.king.in_check?

  #   puts "Sorry! Your move must move the king out of harm's way..."
  #   @board = old_board
  #   piece.pos = old_pos
  #   play_round
  # end

  def update_board(piece, move)
    # Update Board
    remove_capture_piece_from_player(move)
    @board[move[0]][move[1]] = piece
    # Reset Board at piece pos to nil
    @board[piece.pos[0]][piece.pos[1]] = nil
    # Update Piece Pos
    piece.pos = move
  end

  def remove_capture_piece_from_player(move)
    return if @board[move[0]][move[1]].nil?

    piece = @board[move[0]][move[1]]
    @current_player == @player_one ? @player_two.remove(piece) : @player_one.remove(piece)
  end

  def select_piece_and_move
    piece = player_select_piece
    [piece, player_input_move(piece)]
  end

  def player_select_piece
    piece = gets.chomp.split(',').map(&:to_i)
    piece = player_select_piece unless valid_input(piece)
    @board[piece[0]][piece[1]]
  end

  def valid_input(piece)
    return false if piece.length != 2

    piece = @board[piece[0]][piece[1]]
    return false if piece.nil?
    # If Current player pieces includes piece instead!!
    return false unless @current_player.pieces.include?(piece)

    true
  end

  # Maybe Change to a dictionary mapping algebraic notation to array indexes!
  def player_input_move(piece)
    move = gets.chomp.split(',').map(&:to_i)
    move = player_input_move(piece) unless valid_move(piece, move)
    move
  end

  def valid_move(moves, piece, move)
    return false if move.length != 2
    return false unless (0..7).include?(move[0])
    return false unless (0..7).include?(move[1])
    # Make sure move is in piece's available moves!
    return false unless piece.moves.include?(move)
    # If move is in current players all move
    return false unless moves.include?(move)

    true
  end

  def check_message
    if @current_player == @player_one
      puts "#{@player_two.color.capitalize} king is in check!"
    else
      puts "#{@player_one.color.capitalize} king is in check!"
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
