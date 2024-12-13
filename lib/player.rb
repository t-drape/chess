# frozen_string_literal: true

require_relative('./../lib/pieces/rook')
require_relative('./../lib/pieces/pawn')
require_relative('./../lib/pieces/bishop')
require_relative('./../lib/pieces/knight')
require_relative('./../lib/pieces/queen')

# A class to model a chess player
class BlackPlayer
  attr_accessor :pieces, :pawns

  def initialize(board)
    @color = 'black'
    @pawns = create_pawns(board)
    @non_pawns = create_non_pawns(board)
    @pieces = [[@pawns], [@non_pawns]]
  end

  def create_pawns
    pawns = []
    8.times do |t|
      pawn = BlackPawn.new([1, t], board, nil)
      pawns << pawn
      @board[1][t] = pawn
    end
    pawns
  end

  def create_non_pawns
    non_pawns = []
    classes = [BlackRook, BlackKnight, BlackBishop]
    [0, 1, 2].each_with_index do |x_pos, index|
      piece = classes[index].new([0, x_pos], board)
      non_pawns << piece
      @board[0][x_pos] = piece
    end
    queen = BlackQueen.new([0, 3], board)
    non_pawns << queen
    @board[0][3] = queen
    king = BlackKing.new([0, 4], board)
    non_pawns << king
    @board[0][4] = king
    non_pawns
  end

  def legal_moves
  end

  def all_moves
  end
end

class WhitePlayer
  attr_accessor :pieces, :pawns

  def initialize
    @color = 'white'
    @pieces = [[create_pawns], [create_non_pawns]]
  end

  def create_pawns
  end

  def create_non_pawns
  end

  def legal_moves
  end

  def all_moves
  end
end
