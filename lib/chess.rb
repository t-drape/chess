# frozen_string_literal: true

require 'yaml'

require_relative('./../lib/pieces/rook')
require_relative('./../lib/pieces/pawn')
require_relative('./../lib/pieces/bishop')
require_relative('./../lib/pieces/knight')
require_relative('./../lib/pieces/queen')
require_relative('./player')

# A model for the game of Chess
class Game
  attr_accessor :board, :current_player, :new_game

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
    @new_game = true
    @game_id = 0
  end

  def show_board
    @board.each do |index|
      index = index.map do |e|
        e&.code
      end
      p index
    end
  end

  def start_new_game
    start_message
    set_board
    set_piece_boards
  end

  def play_game
    start_new_game if @new_game
    game_over = false
    until game_over == true
      game_over = end_game_check
      play_round
      game_over = game_over ? end_message(@winner) : pause_game
    end
    # end_message(@winner)
  end

  def write_file
    File.open("./chess_games/game_#{@game_id}.yaml", 'w') do |file|
      file.puts YAML.dump(self)
    end
  end

  def dump_data
    Dir.mkdir('./chess_games') unless Dir.exist?('./chess_games')
    unless @new_game == false

      @new_game = false
      @game_id += 1 while Dir.children('./chess_games').include?("game_#{@game_id}.yaml")
    end
    write_file
  end

  def end_message(player)
    if player.nil?
      puts "It's a Draw!"
    else
      puts "#{player.color.capitalize} Player wins!"
    end
    true
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
      @winner = (@current_player == @player_one ? @player_two : @player_one)
      return true
    end
    # Stalemate
    return true if legal.empty?
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
    return false if p_one_pieces.length >= 2 && p_two_pieces.length > 1
    return false if p_one_pieces.length > 1 && p_two_pieces.length >= 2
    return false if p_one_pieces.any? { |e| [WhitePawn, WhiteRook, WhiteQueen].include?(e) }
    return false if p_two_pieces.any? { |e| [BlackPawn, BlackRook, BlackQueen].include?(e) }

    true
  end

  def play_round
    # Show board on each round
    show_board
    # Get piece and move from user
    available_moves = @current_player.legal_moves
    piece, move = select_piece_and_move(available_moves)
    old_pos = piece.pos
    # Update Board
    # If current king is in check
    # old_board = @board
    # old_pos = piece.pos
    update_board(piece, move)
    set_last_moves(piece, old_pos)
    set_piece_boards
    check?
    pawn_change_black
    pawn_change_white
    change_player
    # Move must get King out of check, or keep King out of check

    # UNCOMMENT WHEN PLAYERS ARE MODELED!!!

    # out_of_check(old_board, piece, old_pos)
    # Check if move initiated check
    # check_message if @current_player == @player_one ? @player_two.king.in_check? : @player_one.king_in_check?
    # Update last move of each pawn
  end

  def stop_playing
    choices = %w[y n]
    puts 'Do you wish to stop the game? [Y/N]'
    answer = gets.chomp.downcase
    answer = gets.chomp.downcase unless choices.include?(answer)
    answer == choices[0]
  end

  def pause_game
    choice = stop_playing
    if choice
      puts 'Game Paused!'
      dump_data
      return true
    end
    false
  end

  # Move to pawn file in refactor
  def set_last_moves(piece, old_pos)
    on_start = false
    if @current_player == @player_one
      on_start = true if old_pos[0] == 6
    elsif old_pos[0] == 1
      on_start = true
    end
    @player_two.pieces[0..7].each { |pawn| pawn.last_move = { piece: piece, from_start: on_start } unless pawn.nil? }
    @player_one.pieces[0..7].each { |pawn| pawn.last_move = { piece: piece, from_start: on_start } unless pawn.nil? }
  end

  def check?
    if @current_player == @player_one
      return unless @player_two.pieces[12].in_check?
    else
      return unless @player_one.pieces[12].in_check?
    end
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
    remove_capture_piece_from_player(piece, move)
    @board[move[0]][move[1]] = piece
    # Reset Board at piece pos to nil
    @board[piece.pos[0]][piece.pos[1]] = nil
    update_black_castle?(piece, move) if piece.is_a?(BlackKing)
    update_white_castle?(piece, move) if piece.is_a?(WhiteKing)
    # Update Piece Pos
    piece.pos = move
  end

  def update_white_castle?(piece, move)
    return unless piece.on_opening

    if move == [7, 6]
      @board[7][5] = @board[7][7]
      @board[7][7] = nil
    elsif move == [7, 1]
      @board[7][2] = @board[7][0]
      @board[7][0] = nil
    end
  end

  def update_black_castle?(piece, move)
    return unless piece.on_opening

    if move == [0, 6]
      @board[0][5] = @board[0][7]
      @board[0][7] = nil
    elsif move == [0, 1]
      @board[0][2] = @board[0][0]
      @board[0][0] = nil
    end
  end

  def remove_capture_piece_from_player(new_piece, move)
    piece = @board[move[0]][move[1]]

    # return ep_capture(new_piece, move) if new_piece.is_a?(BlackPawn) || new_piece.is_a?(WhitePawn)
    return ep_capture(new_piece, move) if piece.nil?

    if @current_player == @player_one
      index = @player_two.pieces.index(piece)
      @player_two.pieces[index] = nil
    else
      index = @player_one.pieces.index(piece)
      @player_one.pieces[index] = nil
    end
  end

  def ep_capture(new_piece, move)
    return unless new_piece.is_a?(BlackPawn) || new_piece.is_a?(WhitePawn)

    if @current_player == @player_one
      if new_piece.last_move[:from_start] && move == ([new_piece.last_move[:piece].pos[0] - 1,
                                                       new_piece.last_move[:piece].pos[1]])
        @board[new_piece.last_move[:piece].pos[0]][new_piece.last_move[:piece].pos[1]] = nil
        @player_two.pieces[@player_two.pieces.index(new_piece.last_move[:piece])] = nil
      end
    elsif new_piece.last_move[:from_start] && move == ([new_piece.last_move[:piece].pos[0] + 1,
                                                        new_piece.last_move[:piece].pos[1]])
      @board[new_piece.last_move[:piece].pos[0]][new_piece.last_move[:piece].pos[1]] =
        nil
      @player_one.pieces[@player_one.pieces.index(new_piece.last_move[:piece])] =
        nil
    end
  end

  # def ep_capture(piece, move)
  #   # puts 'It worked!'
  #   if @current_player == @player_one && piece.is_a?(WhitePawn)
  #     if piece.last_move[:from_start] && move == [piece.last_move[:piece].pos[0] - 1, piece.last_move[:piece].pos[1]]

  #       # @player_two.pieces = @player_two.pieces.map { |e| e == piece.last_move[:piece] ? nil : e }
  #       index = @player_two.pieces.index(piece.last_move[:piece])
  #       @player_two.pieces[index] = nil
  #     end
  #   elsif piece.is_a?(BlackPawn)
  #     if piece.last_move[:from_start] && move == [piece.last_move[:piece].pos[0] + 1, piece.last_move[:piece].pos[1]]
  #       index = @player_one.pieces.index(piece.last_move[:piece])
  #       @player_one.pieces[index] = nil
  #     end
  #   end
  # @player_one.pieces = @player_one.pieces.map { |e| e == piece.last_move[:piece] ? nil : e }
  # end

  def select_piece_and_move(moves)
    piece = player_select_piece(moves)
    piece = @board[piece[0]][piece[1]]
    [piece, player_input_move(moves, piece)]
  end

  def player_select_piece(moves)
    puts 'What piece would you like to move?'
    piece = gets.chomp.split(',').map(&:to_i)
    piece = player_select_piece(moves) unless valid_input(piece, moves)
    piece
  end

  def valid_input(piece, all_moves)
    return false if piece.length != 2

    piece = @board[piece[0]][piece[1]]
    return false if piece.nil?
    # If Current player pieces includes piece instead!!
    return false unless @current_player.pieces.include?(piece)
    return false if piece.moves.empty?
    return false unless piece.moves.any? { |e| all_moves.include?(e) }

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
    new_piece = nil
    case piece
    when 'rook'
      new_piece = BlackRook.new([index[0], index[1]], @board)
    when 'bishop'
      new_piece = BlackBishop.new([index[0], index[1]], @board)
    when 'knight'
      new_piece = BlackKnight.new([index[0], index[1]], @board)
    when 'queen'
      new_piece = BlackQueen.new([index[0], index[1]], @board)
    end
    change_index = @player_two.pieces.index(@board[index[0]][index[1]])
    @player_two.pieces[change_index] = nil
    @board[index[0]][index[1]] = new_piece
    @player_two.pieces << new_piece
  end

  def create_new_piece_white(piece, index)
    new_piece = nil
    case piece
    when 'rook'
      new_piece = WhiteRook.new([index[0], index[1]], @board)
    when 'bishop'
      new_piece = WhiteBishop.new([index[0], index[1]], @board)
    when 'knight'
      new_piece = WhiteKnight.new([index[0], index[1]], @board)
    when 'queen'
      new_piece = WhiteQueen.new([index[0], index[1]], @board)
    end
    change_index = @player_one.pieces.index(@board[index[0]][index[1]])
    @player_one.pieces[change_index] = nil
    @board[index[0]][index[1]] = new_piece
    @player_two.pieces << new_piece
  end
end

# Food for thought in refactor
# Make a board class and move all updating function to that class
# Abstract as much as possible and move functions to their classes
# Make set last moves dependent on current player to reduce assignment cost
# Move create new piece to player class
