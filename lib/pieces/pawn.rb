# frozen_string_literal: true

# A class to model a Pawn in chess
class Pawn
  attr_accessor :color, :board

  def initialize(color, pos, board)
    @color = color
    @position = pos
    @board = board
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
    # Capturing moves
    if @color == 'white'
      captures = [[@position[0] - 1, @position[1] - 1], [@position[0] - 1, @position[1] + 1]]
      captures.each do |capture_index|
        captured = @board[capture_index[0]][capture_index[1]]
        end_moves << capture_index unless captured.nil? || captured.color == @color
      end
    else
      captures = [[@position[0] + 1, @position[1] - 1], [@position[0] + 1, @position[1] + 1]]
      captures.each do |capture_index|
        captured = @board[capture_index[0]][capture_index[1]]
        end_moves << capture_index unless captured.nil? || captured.color == @color
      end
    end
    end_moves
  end
end
