# frozen_string_literal: true

# A class to model a black pawn in chess
class BlackPawn
  attr_accessor :color, :board, :opener, :pos, :last_move, :code

  def initialize(pos, board, last_move)
    @code = "\u{265F}"
    @color = 'black'
    @pos = pos
    @opener = @pos[0] == 1
    @board = board
    @last_move = last_move
  end

  def moves
    moves = normal_moves
    moves += en_passant
    moves += capture_moves
    moves
  end

  def opening_moves
    moves = []
    [1, 2].each do |vert_add|
      if @board[@pos[0] + vert_add][@pos[1]].nil?
        moves << [@pos[0] + vert_add, @pos[1]]
      elsif vert_add == 1
        return []
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

  def normal_moves
    moves = []
    moves << [@pos[0] + 1, @pos[1]] if @board[@pos[0] + 1][@pos[1]].nil?
    moves << [@pos[0] + 2, @pos[1]] if @pos[0] == 1 && !moves.empty? && @board[@pos[0] + 2][@pos[1]].nil?
    moves
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

# A class to model a white pawn in chess
class WhitePawn
  attr_accessor :color, :board, :opener, :pos, :last_move, :code

  def initialize(pos, board, last_move)
    @code = "\u{2659}"
    @color = 'white'
    @pos = pos
    @opener = @pos[0] == 6
    @board = board
    @last_move = last_move
  end

  def moves
    moves = normal_moves
    moves += en_passant
    moves += capture_moves
    moves
  end

  def opening_moves
    moves = []
    [1, 2].each do |vert_add|
      if @board[@pos[0] - vert_add][@pos[1]].nil?
        moves << [@pos[0] - vert_add, @pos[1]]
      elsif vert_add == 1
        return []
      end
    end
    moves
  end

  def capture_moves
    # Diagonals to the left, row + 1, column + 1
    moves = []
    y = @pos[0] - 1
    x = @pos[1] + 1
    moves << [y, x] if !@board[y][x].nil? && @board[y][x].color != @color

    # Diagonals to the right, row + 1, column - 1
    x = @pos[1] - 1
    moves << [y, x] if !@board[y][x].nil? && @board[y][x].color != @color
    moves
  end

  def normal_moves
    moves = []
    moves << [@pos[0] - 1, @pos[1]] if @board[@pos[0] - 1][@pos[1]].nil?
    moves << [@pos[0] - 2, @pos[1]] if @pos[0] == 6 && !moves.empty? && @board[@pos[0] - 2][@pos[1]].nil?
    moves
  end

  def en_passant_left
    return unless !@board[@pos[0]][@pos[1] + 1].nil? && @board[@pos[0]][@pos[1] + 1].color != @color
    return unless @last_move[:piece] == @board[@pos[0]][@pos[1] + 1]

    [@pos[0] - 1, @pos[1] + 1] if @last_move[:from_start]
  end

  def en_passant_right
    return unless !@board[@pos[0]][@pos[1] - 1].nil? && @board[@pos[0]][@pos[1] - 1].color != @color
    return unless @last_move[:piece] == @board[@pos[0]][@pos[1] - 1]

    [@pos[0] - 1, @pos[1] - 1] if @last_move[:from_start]
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
