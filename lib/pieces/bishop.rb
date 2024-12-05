# frozen_string_literal: true

# Find all moves for a Black Bishop
module BlackBishopMovement
  def moves
    moves = []
    lows = moves_from_lowest
    highs = moves_to_highest
    lows.each { |e| moves << e } unless lows.empty?
    highs.each { |e| moves << e } unless highs.empty?
    moves
  end

  def moves_from_lowest
    moves = []
    left = from_lowest_left
    right = from_lowest_right
    left.each { |e| moves << e } unless left.empty?
    right.each { |e| moves << e } unless right.empty?
    moves
  end

  def from_lowest_left
    moves = []
    y = @pos[0]
    x = @pos[1]

    while y.positive? && x < 7
      y -= 1
      x += 1
      break if !@board[y][x].nil? && @board[y][x].color == @color

      moves << [y, x]
      break unless @board[y][x].nil?
    end
    moves
  end

  def from_lowest_right
    moves = []
    y = @pos[0]
    x = @pos[1]

    while y.positive? && x.positive?
      y -= 1
      x -= 1
      break if !@board[y][x].nil? && @board[y][x].color == @color

      moves << [y, x]
      break unless @board[y][x].nil?
    end
    moves
  end

  def moves_to_highest
    moves = []
    left = to_highest_left
    right = to_highest_right
    left.each { |e| moves << e } unless left.empty?
    right.each { |e| moves << e } unless right.empty?
    moves
  end

  def to_highest_left
    moves = []
    y = @pos[0]
    x = @pos[1]

    while y < 7 && x < 7
      y += 1
      x += 1
      break if !@board[y][x].nil? && @board[y][x].color == @color

      moves << [y, x]
      break unless @board[y][x].nil?
    end
    moves
  end

  def to_highest_right
    moves = []
    y = @pos[0]
    x = @pos[1]

    while y < 7 && x.positive?
      y += 1
      x -= 1
      break if !@board[y][x].nil? && @board[y][x].color == @color

      moves << [y, x]
      break unless @board[y][x].nil?
    end
    moves
  end
end

# Find all moves for a White BIshop
module WhiteBishopMovement
  def moves
    moves = []
    lows = moves_from_lowest
    highs = moves_to_highest
    lows.each { |e| moves << e } unless lows.empty?
    highs.each { |e| moves << e } unless highs.empty?
    moves
  end

  def moves_from_lowest
    moves = []
    left = from_lowest_left
    right = from_lowest_right
    left.each { |e| moves << e } unless left.empty?
    right.each { |e| moves << e } unless right.empty?
    moves
  end

  def from_lowest_left
    moves = []
    y = @pos[0]
    x = @pos[1]

    while y < 7 && x.positive?
      y += 1
      x -= 1
      break if !@board[y][x].nil? && @board[y][x].color == @color

      moves << [y, x]
      break unless @board[y][x].nil?
    end
    moves
  end

  def from_lowest_right
    moves = []
    y = @pos[0]
    x = @pos[1]

    while y < 7 && x < 7
      y += 1
      x += 1
      break if !@board[y][x].nil? && @board[y][x].color == @color

      moves << [y, x]
      break unless @board[y][x].nil?
    end
    moves
  end

  def moves_to_highest
    moves = []
    left = to_highest_left
    right = to_highest_right
    left.each { |e| moves << e } unless left.empty?
    right.each { |e| moves << e } unless right.empty?
    moves
  end

  def to_highest_left
    moves = []
    y = @pos[0]
    x = @pos[1]

    while y.positive? && x.positive?
      y -= 1
      x -= 1
      break if !@board[y][x].nil? && @board[y][x].color == @color

      moves << [y, x]
      break unless @board[y][x].nil?
    end
    moves
  end

  def to_highest_right
    moves = []
    y = @pos[0]
    x = @pos[1]

    while y.positive? && x < 7
      y -= 1
      x += 1
      break if !@board[y][x].nil? && @board[y][x].color == @color

      moves << [y, x]
      break unless @board[y][x].nil?
    end
    moves
  end
end

# A class to model A Black Bishop in Chess
class BlackBishop
  include BlackBishopMovement

  attr_accessor :color, :board

  def initialize(pos, board)
    @color = 'black'
    @pos = pos
    @board = board
  end
end

# A class to model a White Bishop in Chess
class WhiteBishop
  include WhiteBishopMovement

  attr_accessor :color, :board

  def initialize(pos, board)
    @color = 'white'
    @pos = pos
    @board = board
  end
end
