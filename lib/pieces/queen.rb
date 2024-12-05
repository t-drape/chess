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
    rook = normal_moves
    bishop = moves
    rook.each { |e| return_moves << e } unless rook.nil? || rook.empty?
    bishop.each { |e| return_moves << e } unless bishop.nil? || bishop.empty?
    return_moves
  end
end

# A model of a White Queen in Chess
class WhiteQueen
  include WhiteRookMovement

  include WhiteBishopMovement

  attr_accessor :board

  def initialize(pos, board)
    @color = 'white'
    @pos = pos
    @board = board
  end

  def full_moves
    return_moves = []
    rook = normal_moves
    bishop = moves
    rook.each { |e| return_moves << e } unless rook.nil? || rook.empty?
    bishop.each { |e| return_moves << e } unless bishop.nil? || bishop.empty?
    return_moves
  end
end
