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
