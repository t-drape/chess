# frozen_string_literal: true

class BlackQueen
  def initialize(pos, board)
    @color = 'black'
    @pos = pos
    @board = board
  end
end

class WhiteQueen
  def initialize(pos, board)
    @color = 'white'
    @pos = pos
    @board = board
  end
end
