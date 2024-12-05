# frozen_string_literal: true

require_relative('./../modules/rook_moves')

require_relative('./../modules/bishop_moves')

# A model of a Black Queen in Chess
class BlackQueen
  include BlackRookMovement

  include BlackBishopMovement

  def initialize(pos, board)
    @color = 'black'
    @pos = pos
    @board = board
  end

  def full_moves
  end
end

# A model of a White Queen in Chess
class WhiteQueen
  include WhiteRookMovement

  include WihteBishopMovement

  def initialize(pos, board)
    @color = 'white'
    @pos = pos
    @board = board
  end
end
