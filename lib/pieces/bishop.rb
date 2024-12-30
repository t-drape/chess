# frozen_string_literal: true

require_relative('./../modules/bishop_moves')

# A class to model A Black Bishop in Chess
class BlackBishop
  include BlackBishopMovement

  attr_accessor :color, :board, :pos, :code, :on_opening

  def initialize(pos, board)
    @code = "\u{265D}"
    @color = 'black'
    @pos = pos
    @board = board
    @on_opening = true
  end

  def moves
    bishop_moves
  end
end

# A class to model a White Bishop in Chess
class WhiteBishop
  include WhiteBishopMovement

  attr_accessor :color, :board, :pos, :code, :on_opening

  def initialize(pos, board)
    @code = "\u{2657}"
    @color = 'white'
    @pos = pos
    @board = board
    @on_opening = true
  end

  def moves
    bishop_moves
  end
end
