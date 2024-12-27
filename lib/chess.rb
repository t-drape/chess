require_relative('./../lib/pieces/rook')
require_relative('./../lib/pieces/pawn')
require_relative('./../lib/pieces/bishop')
require_relative('./../lib/pieces/knight')
require_relative('./../lib/pieces/queen')
require_relative('./player')

class Game
  attr_accessor :board, :current_player

  def initialize
    @winner = nil
    @board = [[nil, nil, nil, nil, nil, nil, nil, nil],
              [nil, nil, nil, nil, nil, nil, nil, nil],
              [nil, nil, nil, nil, nil, nil, nil, nil],
              [nil, nil, nil, nil, nil, nil, nil, nil],
              [nil, nil, nil, nil, nil, nil, nil, nil],
              [nil, nil, nil, nil, nil, nil, nil, nil],
              [nil, nil, nil, nil, nil, nil, nil, nil],
              [nil, nil, nil, nil, nil, nil, nil, nil]]
    @player_one = WhitePlayer.new(@board)
    @player_two = BlackPlayer.new(@board)
    @current_player = @player_one
  end

  def show_board
    @board.each do |index|
      index = index.map do |e|
        e&.code
      end
      p index
    end
  end

  # def play_game
  #   set_board
  #   set_piece_boards
  #   start_message
  #   play_round until @winner || end_game_check
  #   end_message(@winner)
  # end

  def end_message(player)
    if player.nil?
      puts "It's a Draw!"
    else
      puts "#{player.color.capitalize} Player wins!"
    end
  end

  def set_board
    @board[0] = @player_two.pieces[8..]
    @board[1] = @player_two.pieces[0..7]
    @board[6] = @player_one.pieces[0..7]
    @board[7] = @player_one.pieces[8..]
  end

  def set_piece_boards
    @player_one.pieces.each { |e| e.board = @board unless e.nil? }
    @player_two.pieces.each { |e| e.board = @board unless e.nil? }
  end

  def start_message
    puts "Welcome to TJ's Chess!"
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
    legal = @current_player.legal_moves
    king = @current_player.pieces[12]
    # Checkmate
    if legal.empty? && king.in_check?
      @winner = @current_player == @player_one ? @player_two : @player_one
      return true
    end
    # Stalemate
    return true if legal.nil?
    # Draw
    # return true if insufficient_material?
    return true if voluntary_draw?

    false
  end

  def voluntary_draw?
    puts "Ask For a Draw? [Y/N]\n"
    answer = gets.chomp
    if answer == 'Y'
      puts "Do You Accept the Draw? [Y/N]\n"
      opponent_answer = gets.chomp
      return true if opponent_answer == 'Y'
    end
    false
  end

  def insufficient_material?
    # Insufficient material:
    # King vs king with no other pieces.
    # King and bishop vs king.
    # King and knight vs king.
    p_one_pieces = @player_one.pieces.compact
    p_two_pieces = @player_two.pieces.compact
    return true if p_one_pieces.length == 2 && p_two_pieces.length > 1
    return true if p_one_pieces.length > 1 && p_two_pieces.length == 2
    return true if p_one_pieces.any? { |e| ![WhiteKing, WhiteBishop, WhiteKnight].include?(e) }
    return true if p_two_pieces.any? { |e| ![BlackKing, BlackBIshop, BlackKnight].include?(e) }

    false
  end

  def play_round
    # Show board on each round
    show_board
    # Get piece and move from user
    available_moves = @current_player.legal_moves
    piece, move = select_piece_and_move(available_moves)
    # Update Board
    # If current king is in check
    # old_board = @board
    # old_pos = piece.pos
    set_last_moves(piece)
    update_board(piece, move)
    set_piece_boards
    check?
    change_player
    # Move must get King out of check, or keep King out of check

    # UNCOMMENT WHEN PLAYERS ARE MODELED!!!

    # out_of_check(old_board, piece, old_pos)
    # Check if move initiated check
    # check_message if @current_player == @player_one ? @player_two.king.in_check? : @player_one.king_in_check?
    # Update last move of each pawn
  end

  def set_last_moves(piece)
    on_start = false
    if piece.is_a?(WhitePawn)
      on_start = piece.pos[0] == 6
    elsif piece.is_a?(BlackPawn)
      on_start = piece.pos[0] == 1
    end
    @player_two.pieces[0..7].each { |e| e.last_move = { piece: piece, from_start: on_start } unless e.nil? }
    @player_one.pieces[0..7].each { |e| e.last_move = { piece: piece, from_start: on_start } unless e.nil? }
  end

  def check?
    return unless @current_player == @player_one ? @player_two.pieces[12].in_check? : @player_one.pieces[12].in_check?

    check_message
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
    if @current_player == @player_one
      index = @player_two.pieces.index(piece)
      @player_two.pieces[index] = nil
    else
      index = @player_one.pieces.index(Piece)
      @player_one.pieces[index] = nil
    end
  end

  def select_piece_and_move(moves)
    piece = player_select_piece
    piece = @board[piece[0]][piece[1]]
    [piece, player_input_move(moves, piece)]
  end

  def player_select_piece
    puts 'What piece would you like to move?'
    piece = gets.chomp.split(',').map(&:to_i)
    piece = player_select_piece unless valid_input(piece)
    piece
  end

  def valid_input(piece)
    return false if piece.length != 2

    piece = @board[piece[0]][piece[1]]
    return false if piece.nil?
    # If Current player pieces includes piece instead!!
    return false unless @current_player.pieces.include?(piece)
    return false if piece.moves.empty?

    true
  end

  # Maybe Change to a dictionary mapping algebraic notation to array indexes!
  def player_input_move(available_moves, piece)
    puts 'Where would you like to move it to?'
    move = gets.chomp.split(',').map(&:to_i)
    move = player_input_move(available_moves, piece) unless valid_move(available_moves, piece, move)
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

# x = Game.new
# x.play_game
