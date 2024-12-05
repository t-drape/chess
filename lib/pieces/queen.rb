# frozen_string_literal: true

require_relative('./../modules/rook_moves')

require_relative('./../modules/bishop_moves')

# A model of a Black Queen in Chess
class BlackQueen
  include BlackRookMovement

  include BlackBishopMovement

  attr_accessor :board

  def initialize(pos, board)
    @color = 'black'
    @pos = pos
    @board = board
  end

  def full_moves
    return_moves = []
    bishop = moves
    rook = normal_moves
    bishop.each { |e| moves << e } unless bishop.empty?
    rook.each { |e| moves << e } unless rook.empty?
    return_moves
  end
end

# A model of a White Queen in Chess
class WhiteQueen
  include WhiteRookMovement

  include WhiteBishopMovement

  def initialize(pos, board)
    @color = 'white'
    @pos = pos
    @board = board
  end
end
