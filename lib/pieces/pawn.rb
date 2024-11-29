# frozen_string_literal: true

# A class to model a Pawn in chess
class Pawn
  attr_accessor :color, :board

  def initialize(color, pos, board, last_move)
    @color = color
    @position = pos
    @board = board
    @last_move = last_move
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
    # Regular Moves
    moves = [1]
    moves << 2 if on_opening?
    moves = moves.map(&:-@) if @color == 'white'
    end_moves = []
    moves.each do |vert_add|
      end_moves << [@position[0] + vert_add, @position[1]] if @board[@position[0] + vert_add][@position[1]].nil?
    end
    end_moves = [] if on_opening? && !@board[@position[0] - 1][@position[1]].nil? && @color == 'white'
    end_moves = [] if on_opening? && !@board[@position[0] + 1][@position[1]].nil? && @color == 'black'

    # Capturing Moves
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

    # En Passant Moves
    if !@last_move.nil? && @last_move[:piece].color != @color && @last_move[:type] == 'pawn'
      if @board[@position[0]][@position[1] + 1] == @board[@last_move[:end][0]][@last_move[:end][1]]
        end_moves << (if @color == 'black'
                        [@last_move[:end][0] + 1,
                         @last_move[:end][1]]
                      else
                        [@last_move[:end][0] - 1,
                         @last_move[:end][1]]
                      end)
      elsif @board[@position[0]][@position[1] - 1] == @board[@last_move[:end][0]][@last_move[:end][1]]
        end_moves << (if @color == 'black'
                        [@last_move[:end][0] + 1,
                         @last_move[:end][1]]
                      else
                        [@last_move[:end][0] - 1,
                         @last_move[:end][1]]
                      end)
      end
    end
    end_moves
  end
end

class BlackPawn
  attr_accessor :color

  def initialize(pos)
    @color = 'black'
    @pos = pos
  end
end

class WhitePawn
end
