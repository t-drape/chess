# frozen_string_literal: true

require_relative('./../lib/pieces/rook')
require_relative('./../lib/pieces/pawn')
require_relative('./../lib/pieces/bishop')
require_relative('./../lib/pieces/knight')
require_relative('./../lib/pieces/queen')

# A class to model a chess player
class BlackPlayer
  attr_accessor :pieces, :pawns, :non_pawns, :board

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
    pawns
  end

  def create_non_pawns
    non_pawns = []
    classes = [BlackRook, BlackKnight, BlackBishop, BlackQueen, BlackKing, BlackBishop, BlackKnight, BlackRook]
    [0, 1, 2, 3, 4, 5, 6, 7].each_with_index do |x_pos, index|
      piece = classes[index].new([0, x_pos], @board)
      non_pawns << piece
    end
    non_pawns
  end

  def legal_moves
    moves = []
    king = @non_pawns[4]
    @pieces.each do |piece|
      p piece if piece.nil?
      piece_moves = piece.moves
      piece_moves.each do |move|
        old_pos = piece.pos
        old_spot = @board[move[0]][move[1]]
        piece.pos = move
        @board[old_pos[0]][old_pos[1]] = nil
        @board[move[0]][move[1]] = piece
        king.board = @board
        moves << move unless king.in_check? || moves.include?(move)
        piece.pos = old_pos
        @board[move[0]][move[1]] = old_spot
        @board[old_pos[0]][old_pos[1]] = piece
        king.board = @board
      end
    end
    moves
  end
end

class WhitePlayer
  attr_accessor :pieces, :pawns, :non_pawns, :board

  def initialize(board)
    @color = 'white'
    @board = board
    @pawns = create_pawns
    @non_pawns = create_non_pawns
    @pieces = @pawns + @non_pawns
  end

  def create_pawns
    pawns = []
    8.times do |t|
      pawn = WhitePawn.new([6, t], board, nil)
      pawns << pawn
    end
    pawns
  end

  def create_non_pawns
    non_pawns = []
    classes = [WhiteRook, WhiteKnight, WhiteBishop, WhiteQueen, WhiteKing, WhiteBishop, WhiteKnight, WhiteRook]
    [0, 1, 2, 3, 4, 5, 6, 7].each_with_index do |x_pos, index|
      piece = classes[index].new([7, x_pos], @board)
      non_pawns << piece
    end
    non_pawns
  end

  def legal_moves
    moves = []
    king = @non_pawns[4]
    @pieces.each do |piece|
      next if piece.nil?

      piece_moves = piece.moves
      piece_moves.each do |move|
        old_pos = piece.pos
        old_spot = @board[move[0]][move[1]]
        piece.pos = move
        @board[old_pos[0]][old_pos[1]] = nil
        @board[move[0]][move[1]] = piece
        king.board = @board
        moves << move unless king.in_check? || moves.include?(move)
        piece.pos = old_pos
        @board[move[0]][move[1]] = old_spot
        @board[old_pos[0]][old_pos[1]] = piece
        king.board = @board
      end
    end
    moves
  end
end
