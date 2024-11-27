# frozen_string_literal: true

# A class to model a Pawn in chess
class Pawn
  def initialize(color, pos)
    @color = color
    @position = pos
  end

  def on_opening?
    if @color == 'black' && @position[0] == 1
      return true
    elsif @color == 'white' && @position[0] == 6
      return true
    end

    false
  end

  def available_moves
    moves = [1]
    moves << 2 if on_opening?
    moves = moves.map(&:-@) if @color == 'white'
    end_moves = []
    moves.each do |vert_add|
      end_moves << [@position[0] + vert_add, @position[1]]
    end
    end_moves
  end
end
