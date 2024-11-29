class BlackKnight
  def initialize(pos, board, last_move)
    @color = 'black'
    @pos = pos
    @board = board
    @last_move = last_move
  end
end

class WhiteKnight
  def initialize(pos, board, last_move)
    @color = 'white'
    @pos = pos
    @board = board
    @last_move = last_move
  end
end
