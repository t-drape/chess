# frozen_string_literal: true

require_relative './rook'

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
      moves << [new_height, new_width] if new_height.between?(0, 7) && new_width.between?(0, 7)
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

    [7, 2]
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
end
