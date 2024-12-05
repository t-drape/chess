# frozen_string_literal: true

require_relative('./../modules/rook_moves')

require_relative('./../modules/bishop_moves')

class BlackQueen
  include BlackRookMovement

  include BlackBishopMovement

  def initialize(pos, board)
    @color = 'black'
    @pos = pos
    @board = board
  end
end

class WhiteQueen
  include WhiteRookMovement

  include WihteBishopMovement

  def initialize(pos, board)
    @color = 'white'
    @pos = pos
    @board = board
  end
end
