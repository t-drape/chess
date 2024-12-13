# frozen_string_literal: true

require_relative('./../lib/pieces/rook')
require_relative('./../lib/pieces/pawn')
require_relative('./../lib/pieces/bishop')
require_relative('./../lib/pieces/knight')
require_relative('./../lib/pieces/queen')

# A class to model a chess player
class BlackPlayer
  attr_accessor :pieces, :pawns, :non_pawns

  def initialize(board)
    @color = 'black'
    @board = board
    @pawns = create_pawns
    @non_pawns = create_non_pawns
    @pieces = @pawns + @non_pawns
  end

  def create_pawns
    pawns = []
    8.times do |t|
      pawn = BlackPawn.new([1, t], @board, nil)
      pawns << pawn
    end
    pawns.each { |e| e.board = @board }
    pawns
  end

  def create_non_pawns
    non_pawns = []
    classes = [BlackRook, BlackKnight, BlackBishop, BlackQueen, BlackKing, BlackBishop, BlackKnight, BlackRook]
    [0, 1, 2, 3, 4, 5, 6, 7].each_with_index do |x_pos, index|
      piece = classes[index].new([0, x_pos], @board)
      non_pawns << piece
    end
    non_pawns.each { |e| e.board = @board }
    non_pawns
  end

  def legal_moves(board)
    moves = []
    puts @non_pawns[4]
    @pieces.each do |piece|
      piece_moves = piece.moves
      piece_moves.each do |move|
        new_board = board
        new_board[piece.pos[0]][piece.pos[1]] = nil
        new_board[move[0]][move[1]] = piece
        test_king = BlackKing.new(@non_pawns[4].pos, new_board)
        moves << move unless test_king.in_check?
      end
    end
    moves.uniq
  end
end

class WhitePlayer
  attr_accessor :pieces, :pawns

  def initialize(board)
    @color = 'white'
    @pawns = create_pawns(board)
    @non_pawns = create_non_pawns(board)
    @pieces = @pawns + @non_pawns
  end

  def create_pawns(board)
    pawns = []
    8.times do |t|
      pawn = WhitePawn.new([6, t], board, nil)
      pawns << pawn
      board[6][t] = pawn
    end
    pawns
  end

  def create_non_pawns(board)
    non_pawns = []
    classes = [WhiteRook, WhiteKnight, WhiteBishop]
    [0, 1, 2].each_with_index do |x_pos, index|
      piece = classes[index].new([7, x_pos], board)
      piece_two = classes[index].new([7, 7 - x_pos], board)
      non_pawns << piece
      non_pawns << piece_two
      board[7][x_pos] = piece
      board[7][7 - x_pos] = piece_two
    end
    queen = WhiteQueen.new([7, 3], board)
    non_pawns << queen
    board[7][3] = queen
    king = WhiteKing.new([7, 4], board)
    non_pawns << king
    board[7][4] = king
    non_pawns
  end

  def legal_moves(board)
    moves = []
    @pieces.each do |piece|
      piece_moves = piece.moves
      piece_moves.each do |move|
        new_board = board
        new_board[piece.pos[0]][piece.pos[1]] = nil
        new_board[move[0]][move[1]] = piece
        test_king = WhiteKing.new([@non_pawns[4].pos[0]][@non_pawns[4].pos[0]])
        moves << move unless test_king.in_check?
      end
    end
    moves
  end
end
