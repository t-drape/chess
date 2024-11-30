# frozen_string_literal: true

# A model of a Black Rook in Chess
class BlackRook
  def initialize(pos, board)
    @color = 'black'
    @pos = pos
    @board = board
  end
end

# A model of a White Rook in Chess
class WhiteRook
  def initialize(pos, board)
    @color = 'white'
    @pos = pos
    @board = board
  end
end
