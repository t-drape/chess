# frozen_string_literal: true

# A model of a Black Rook in Chess
class BlackRook
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

  def normal_moves
    moves = []
    vertical = vertical_moves
    horizontal = horizontal_moves
    vertical.each { |e| moves << e } unless vertical.empty?
    horizontal.each { |e| moves << e } unless horizontal.empty?
    moves
  end

  def vertical_moves
  end

  def horizontal_moves
  end

  def castling
  end
end

# A model of a White Rook in Chess
class WhiteRook
  attr_accessor :color, :on_opening

  def initialize(pos, board)
    @color = 'white'
    @pos = pos
    @board = board
    @on_opening = true
  end
end

# Run a loop for rook moves
# From current square to end of column,
# If at any point the current spot is taken,
# Include it in the moves array,
# Stop the Loop
