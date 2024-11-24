# frozen_string_literal: true

# A class to model a king in chess
class King
  attr_accessor :pos

  def initialize(pos)
    @position = pos
  end

  def available_moves
    position_vertical = @position[0]
    position_horizontal = @position[1]
  end
end
