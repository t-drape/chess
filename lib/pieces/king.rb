# frozen_string_literal: true

require_relative './rook'
require_relative './queen'
require_relative './pawn'
require_relative './bishop'
require_relative './knight'

# A model of a Black King in Chess
class BlackKing
  attr_accessor :pos, :board, :on_opening, :color

  def initialize(pos, board)
    @color = 'black'
    @pos = pos
    @board = board
    @on_opening = true
    @movements = [[-1, -1], [-1, 0], [-1, 1], [0, -1], [0, 1], [1, -1], [1, 0], [1, 1]]
  end

  def normal_moves
    moves = []
    @movements.each do |e|
      new_height = @pos[0] + e[0]
      new_width = @pos[1] + e[1]
      if new_height.between?(0, 7) && new_width.between?(0, 7) && @board[new_height][new_width].nil?
        moves << [new_height, new_width]
      end
    end
    moves
  end

  def castling_right
    return unless @on_opening

    rook = @board[0][0]
    return unless @board[0][1].nil? && @board[0][2].nil? && @board[0][3].nil?
    return unless rook.is_a?(BlackRook) && rook.color == 'black' && rook.on_opening

    [0, 1]
  end

  def castling_left
    return unless @on_opening

    rook = @board[0][7]
    return unless @board[0][5].nil? && @board[0][6].nil?
    return unless rook.is_a?(BlackRook) && rook.color == 'black' && rook.on_opening

    [0, 6]
  end

  def castling
    moves = []
    left = castling_left
    right = castling_right
    moves << left unless left.nil?
    moves << right unless right.nil?
    moves
  end

  def moves
    moves = []
    normal = normal_moves
    castles = castling
    normal.each { |e| moves << e } unless normal.empty?
    castles.each { |e| moves << e } unless castles.empty?
    moves
  end

  def in_check?
    in_check_vertical? || in_check_horizontal? || in_check_diagonal? || special_checks?
  end

  def special_checks?
    in_pawn_check? || in_knight_check?
  end

  def in_pawn_check?
    y = @pos[0] + 1
    x_vals = [@pos[1] + 1, @pos[1] - 1]
    x_vals.each do |x|
      return true if !@board[y][x].nil? && @board[y][x].is_a?(WhitePawn)
    end
    false
  end

  def in_knight_check?
    [[-2, 1], [-2, -1], [-1, 2], [-1, -2], [1, 2], [1, -2], [2, 1], [2, -1]].each do |move|
      y = @pos[0] + move[0]
      x = @pos[1] + move[1]
      return true if !@board[y][x].nil? && @board[y][x].is_a?(WhiteKnight)
    end
    false
  end

  def in_check_vertical?
    in_check_up? || in_check_down?
  end

  def in_check_up?
    y = @pos[0]
    while y < 7
      y += 1
      unless @board[y][@pos[1]].nil?
        break if @board[y][@pos[1]].color == @color
        return true if @board[y][@pos[1]].is_a?(WhiteRook) || @board[y][@pos[1]].is_a?(WhiteQueen)
      end
    end
    false
  end

  def in_check_down?
    y = @pos[0]
    while y.positive?
      y -= 1
      unless @board[y][@pos[1]].nil?
        break if @board[y][@pos[1]].color == @color
        return true if @board[y][@pos[1]].is_a?(WhiteRook) || @board[y][@pos[1]].is_a?(WhiteQueen)
      end
    end
    false
  end

  def in_check_horizontal?
    in_check_left? || in_check_right?
  end

  def in_check_left?
    x = @pos[1]
    while x.positive?
      x -= 1
      unless @board[@pos[0]][x].nil?
        break if @board[@pos[0]][x].color == @color
        return true if @board[@pos[0]][x].is_a?(WhiteRook) || @board[@pos[0]][x].is_a?(WhiteQueen)
      end
    end
    false
  end

  def in_check_right?
    x = @pos[1]
    while x < 7
      x += 1
      unless @board[@pos[0]][x].nil?
        break if @board[@pos[0]][x].color == @color
        return true if @board[@pos[0]][x].is_a?(WhiteRook) || @board[@pos[0]][x].is_a?(WhiteQueen)
      end
    end
    false
  end

  def in_check_diagonal?
    in_check_left_up? || in_check_left_down? || in_check_right_up? || in_check_right_down?
  end

  def in_check_left_up?
    y, x = @pos
    while y < 7 && x.positive?
      y += 1
      x -= 1
      unless @board[y][x].nil?
        break if @board[y][x].color == @color
        return true if @board[y][x].is_a?(WhiteBishop) || @board[y][x].is_a?(WhiteQueen)
      end
    end
    false
  end

  def in_check_left_down?
    y, x = @pos
    while y.positive? && x.positive?
      y -= 1
      x -= 1
      unless @board[y][x].nil?
        break if @board[y][x].color == @color
        return true if @board[y][x].is_a?(WhiteBishop) || @board[y][x].is_a?(WhiteQueen)
      end
    end
    false
  end

  def in_check_right_up?
    y, x = @pos
    while y < 7 && x < 7
      y += 1
      x += 1
      unless @board[y][x].nil?
        break if @board[y][x].color == @color
        return true if @board[y][x].is_a?(WhiteBishop) || @board[y][x].is_a?(WhiteQueen)
      end
    end
    false
  end

  def in_check_right_down?
    y, x = @pos
    while y.positive? && x < 7
      y -= 1
      x += 1
      unless @board[y][x].nil?
        break if @board[y][x].color == @color
        return true if @board[y][x].is_a?(WhiteBishop) || @board[y][x].is_a?(WhiteQueen)
      end
    end
    false
  end
end

# A model of a White King in Chess
class WhiteKing
  attr_accessor :pos, :board, :on_opening, :color

  def initialize(pos, board)
    @color = 'white'
    @pos = pos
    @board = board
    @on_opening = true
    @movements = [[-1, -1], [-1, 0], [-1, 1], [0, -1], [0, 1], [1, -1], [1, 0], [1, 1]]
  end

  def normal_moves
    moves = []
    @movements.each do |e|
      new_height = @pos[0] + e[0]
      new_width = @pos[1] + e[1]
      moves << [new_height, new_width] if new_height.between?(0, 7) && new_width.between?(0, 7)
    end
    moves
  end

  def castling_left
    return unless @on_opening

    rook = @board[7][0]
    return unless @board[7][1].nil? && @board[7][2].nil? && @board[7][3].nil?
    return unless rook.is_a?(WhiteRook) && rook.color == 'white' && rook.on_opening

    [7, 1]
  end

  def castling_right
    return unless @on_opening

    rook = @board[7][7]
    return unless @board[7][5].nil? && @board[7][6].nil?
    return unless rook.is_a?(WhiteRook) && rook.color == 'white' && rook.on_opening

    [7, 6]
  end

  def castling
    moves = []
    left = castling_left
    right = castling_right
    moves << left unless left.nil?
    moves << right unless right.nil?
    moves
  end

  def moves
    moves = []
    normal = normal_moves
    castles = castling
    normal.each { |e| moves << e } unless normal.empty?
    castles.each { |e| moves << e } unless castles.empty?
    moves
  end

  def in_check?
    in_check_vertical? || in_check_horizontal? || in_check_diagonal? || special_checks?
  end

  def special_checks?
    in_pawn_check? || in_knight_check?
  end

  def in_pawn_check?
    y = @pos[0] - 1
    x_vals = [@pos[1] + 1, @pos[1] - 1]
    x_vals.each do |x|
      return true if !@board[y][x].nil? && @board[y][x].is_a?(BlackPawn)
    end
    false
  end

  def in_knight_check?
    [[-2, 1], [-2, -1], [-1, 2], [-1, -2], [1, 2], [1, -2], [2, 1], [2, -1]].each do |move|
      y = @pos[0] + move[0]
      x = @pos[1] + move[1]
      return true if !@board[y][x].nil? && @board[y][x].is_a?(BlackKnight)
    end
    false
  end

  def in_check_vertical?
    in_check_up? || in_check_down?
  end

  def in_check_up?
    y = @pos[0]
    while y.positive?
      y -= 1
      unless @board[y][@pos[1]].nil?
        break if @board[y][@pos[1]].color == @color
        return true if @board[y][@pos[1]].is_a?(BlackRook) || @board[y][@pos[1]].is_a?(BlackQueen)
      end
    end
    false
  end

  def in_check_down?
    y = @pos[0]
    while y < 7
      y += 1
      unless @board[y][@pos[1]].nil?
        break if @board[y][@pos[1]].color == @color
        return true if @board[y][@pos[1]].is_a?(BlackRook) || @board[y][@pos[1]].is_a?(BlackQueen)
      end
    end
    false
  end

  def in_check_horizontal?
    in_check_left? || in_check_right?
  end

  def in_check_left?
    x = @pos[1]
    while x < 7
      x += 1
      unless @board[@pos[0]][x].nil?
        break if @board[@pos[0]][x].color == @color
        return true if @board[@pos[0]][x].is_a?(BlackRook) || @board[@pos[0]][x].is_a?(BlackQueen)
      end
    end
    false
  end

  def in_check_right?
    x = @pos[1]
    while x.positive?
      x -= 1
      unless @board[@pos[0]][x].nil?
        break if @board[@pos[0]][x].color == @color
        return true if @board[@pos[0]][x].is_a?(BlackRook) || @board[@pos[0]][x].is_a?(BlackQueen)
      end
    end
    false
  end

  def in_check_diagonal?
    in_check_left_up? || in_check_left_down? || in_check_right_up? || in_check_right_down?
  end

  def in_check_right_down?
    y, x = @pos
    while y < 7 && x.positive?
      y += 1
      x -= 1
      unless @board[y][x].nil?
        break if @board[y][x].color == @color
        return true if @board[y][x].is_a?(BlackBishop) || @board[y][x].is_a?(BlackQueen)
      end
    end
    false
  end

  def in_check_right_up?
    y, x = @pos
    while y.positive? && x.positive?
      y -= 1
      x -= 1
      unless @board[y][x].nil?
        break if @board[y][x].color == @color
        return true if @board[y][x].is_a?(BlackBishop) || @board[y][x].is_a?(BlackQueen)
      end
    end
    false
  end

  def in_check_left_down?
    y, x = @pos
    while y < 7 && x < 7
      y += 1
      x += 1
      unless @board[y][x].nil?
        break if @board[y][x].color == @color
        return true if @board[y][x].is_a?(BlackBishop) || @board[y][x].is_a?(BlackQueen)
      end
    end
    false
  end

  def in_check_left_up?
    y, x = @pos
    while y.positive? && x < 7
      y -= 1
      x += 1
      unless @board[y][x].nil?
        break if @board[y][x].color == @color
        return true if @board[y][x].is_a?(BlackBishop) || @board[y][x].is_a?(BlackQueen)
      end
    end
    false
  end
end
