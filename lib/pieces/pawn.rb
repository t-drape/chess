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
  attr_accessor :color, :board, :opener

  def initialize(pos, board, last_move)
    @color = 'black'
    @pos = pos
    @opener = @pos[0] == 1
    @board = board
    @last_move = last_move
  end

  def opening_moves
    moves = []
    [1, 2].each do |vert_add|
      if @board[@pos[0] + vert_add][@pos[1]].nil?
        moves << [@pos[0] + vert_add, @pos[1]]
      elsif vert_add == 1
        return nil
      end
    end
    moves
  end

  def capture_moves
    # Diagonals to the left, row + 1, column + 1
    moves = []
    y = @pos[0] + 1
    x = @pos[1] + 1
    moves << [y, x] if !@board[y][x].nil? && @board[y][x].color != @color

    # Diagonals to the right, row + 1, column - 1
    x = @pos[1] - 1
    moves << [y, x] if !@board[y][x].nil? && @board[y][x].color != @color
    moves
  end

  def non_opening_moves
    [@pos[0] + 1, @pos[1]] if @board[@pos[0] + 1][@pos[1]].nil?
  end

  def en_passant_left
    return unless !@board[@pos[0]][@pos[1] + 1].nil? && @board[@pos[0]][@pos[1] + 1].color != @color
    return unless @last_move[:piece] == @board[@pos[0]][@pos[1] + 1]

    [@pos[0] + 1, @pos[1] + 1] if @last_move[:from_start]
  end

  def en_passant_right
    return unless !@board[@pos[0]][@pos[1] - 1].nil? && @board[@pos[0]][@pos[1] - 1].color != @color
    return unless @last_move[:piece] == @board[@pos[0]][@pos[1] - 1]

    [@pos[0] + 1, @pos[1] - 1] if @last_move[:from_start]
  end

  def en_passant
    moves = []
    left = en_passant_left
    right = en_passant_right
    moves << left unless left.nil?
    moves << right unless right.nil?
    moves
  end
end

class WhitePawn
  attr_accessor :color, :board, :opener

  def initialize(pos, board, last_move)
    @color = 'white'
    @pos = pos
    @opener = @pos[0] == 6
    @board = board
    @last_move = last_move
  end
end
