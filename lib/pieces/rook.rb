# frozen_string_literal: true

require_relative('./../modules/rook_moves')
require_relative('./king')

# A model of a Black Rook in Chess
class BlackRook
  include BlackRookMovement

  attr_accessor :color, :board, :on_opening

  def initialize(pos, board)
    @color = 'black'
    @pos = pos
    @board = board
    @on_opening = true
  end

  def moves
    moves = []
    normal = normal_moves
    castles = castling
    normal.each { |e| moves << e } unless normal.empty?
    castles.each { |e| moves << e } unless castles.empty?
    moves
  end

  def castling
    moves = []
    left = castling_left
    right = castling_right
    moves << left unless left.nil?
    moves << right unless right.nil?
    moves
  end

  def castling_left
    return unless @on_opening

    king = @board[0][4]
    return unless @board[0][5].nil? && @board[0][6].nil?
    return unless king.is_a?(BlackKing) && king.on_opening

    [0, 5]
  end

  def castling_right
    return unless @on_opening

    king = @board[0][4]
    return unless @board[0][1].nil? && @board[0][2].nil? && @board[0][3].nil?
    return unless king.is_a?(BlackKing) && king.on_opening

    [0, 2]
  end
end

# A model of a White Rook in Chess
class WhiteRook
  include WhiteRookMovement

  attr_accessor :color, :on_opening, :board

  def initialize(pos, board)
    @color = 'white'
    @pos = pos
    @board = board
    @on_opening = true
  end

  def moves
    moves = []
    normal = normal_moves
    castles = castling
    normal.each { |e| moves << e } unless normal.empty?
    castles.each { |e| moves << e } unless castles.empty?
    moves
  end

  def castling
    moves = []
    left = castling_left
    right = castling_right
    moves << left unless left.nil?
    moves << right unless right.nil?
    moves
  end

  def castling_left
    return unless @on_opening

    king = @board[7][4]
    return unless @board[7][1].nil? && @board[7][2].nil? && @board[7][3].nil?
    return unless king.is_a?(WhiteKing) && king.on_opening

    [7, 2]
  end

  def castling_right
    return unless @on_opening

    king = @board[7][4]
    return unless @board[7][5].nil? && @board[7][6].nil?
    return unless king.is_a?(WhiteKing) && king.on_opening

    [7, 5]
  end
end

# Run a loop for rook moves
# From current square to end of column,
# If at any point the current spot is taken,
# Include it in the moves array,
# Stop the Loop
