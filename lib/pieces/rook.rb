# frozen_string_literal: true

# A model of a Black Rook in Chess
class BlackRook
  attr_accessor :color, :on_opening

  def initialize(pos, board)
    @color = 'black'
    @pos = pos
    @board = board
    @on_opening = true
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
