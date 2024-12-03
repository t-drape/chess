class BlackBishop
  attr_accessor :color, :board

  def initialize(pos, board)
    @color = 'black'
    @pos = pos
    @board = board
  end
end

class WhiteBishop
  attr_accessor :color, :board

  def initialize(pos, board)
    @color = 'white'
    @pos = pos
    @board = board
  end
end
