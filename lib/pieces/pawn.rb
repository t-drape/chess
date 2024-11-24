# frozen_string_literal: true

# A class to model a pawn in chess
class Pawn
  def initialize(pos)
    @position = pos
    @on_opening_square = true
  end

  def available_moves
    height = @position[0]
    width = @position[1]
    [[height + 1, width], [height + 2, width]]
  end
end
