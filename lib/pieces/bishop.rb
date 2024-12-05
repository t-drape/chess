# frozen_string_literal: true

require_relative('./../modules/bishop_moves')

# A class to model A Black Bishop in Chess
class BlackBishop
  include BlackBishopMovement

  attr_accessor :color, :board

  def initialize(pos, board)
    @color = 'black'
    @pos = pos
    @board = board
  end
end

# A class to model a White Bishop in Chess
class WhiteBishop
  include WhiteBishopMovement

  attr_accessor :color, :board

  def initialize(pos, board)
    @color = 'white'
    @pos = pos
    @board = board
  end
end
