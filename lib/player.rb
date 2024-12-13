# frozen_string_literal: true

require_relative('./../lib/pieces/rook')
require_relative('./../lib/pieces/pawn')
require_relative('./../lib/pieces/bishop')
require_relative('./../lib/pieces/knight')
require_relative('./../lib/pieces/queen')

# A class to model a chess player
class BlackPlayer
  attr_accessor :pieces

  def initialize
    @color = 'black'
    @pawns = create_pawns
    @non_pawns = create_non_pawns
    @pieces = [[pawns], [non_pawns]]
  end

  def create_pawns
    8.times do
      BlackPawn.new
    end
  end

  def create_non_pawns
  end

  def legal_moves
  end

  def all_moves
  end
end

class WhitePlayer
  def initialize
    @color = 'white'
    @pieces = [[create_pawns], [create_non_pawns]]
  end

  def create_pawns
  end

  def create_non_pawns
  end

  def legal_moves
  end

  def all_moves
  end
end
