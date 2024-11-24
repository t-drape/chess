# frozen_string_literal: true

# A class to model a king in chess
class King
  attr_accessor :pos

  def initialize(pos)
    @position = pos
    @movements = [[-1, -1], [-1, 0], [-1, 1], [0, -1], [0, 1], [1, -1], [1, 0], [1, 1]]
  end

  def all_moves
    moves = []
    @movements.each do |e|
      new_height = @position[0] + e[0]
      new_width = @position[1] + e[1]
      moves << [new_height, new_width] if new_height.between?(0, 7) && new_width.between?(0, 7)
    end
    moves
  end
end
