# frozen_string_literal: true

# A model for a Black Knight in Chess
class BlackKnight
  attr_accessor :color, :board, :pos, :code, :on_opening

  def initialize(pos, board)
    @code = "\u{265E}"
    @color = 'black'
    @pos = pos
    @board = board
    @on_opening = true
  end

  def moves
    moves = []
    # Get Left Moves
    left = left_moves
    # Get Right Moves
    right = right_moves
    # Add Left Moves
    left&.each { |e| moves << e }
    # Add Right Moves
    right&.each { |e| moves << e }
    moves
  end

  def left_moves
    board_range = (0..7)
    moves = []
    [[-2, 1], [-1, 2], [1, 2], [2, 1]].each do |y, x|
      next unless board_range.include?(@pos[0] + y) && board_range.include?(@pos[1] + x)
      next unless @board[@pos[0] + y][@pos[1] + x].nil? || @board[@pos[0] + y][@pos[1] + x].color != 'black'

      moves << [@pos[0] + y,
                @pos[1] + x]
    end
    moves
  end

  def right_moves
    board_range = (0..7)
    moves = []
    [[-2, -1], [-1, -2], [1, -2], [2, -1]].each do |y, x|
      next unless board_range.include?(@pos[0] + y) && board_range.include?(@pos[1] + x)
      next unless @board[@pos[0] + y][@pos[1] + x].nil? || @board[@pos[0] + y][@pos[1] + x].color != 'black'

      moves << [@pos[0] + y,
                @pos[1] + x]
    end
    moves
  end
end

# A model for a White Knight in Chess
class WhiteKnight
  attr_accessor :color, :board, :pos, :code, :on_opening

  def initialize(pos, board)
    @code = "\u{2658}"
    @color = 'white'
    @pos = pos
    @board = board
    @on_opening
  end

  def moves
    moves = []
    # Get Left Moves
    left = left_moves
    # Get Right Moves
    right = right_moves
    # Add Left Moves
    left&.each { |e| moves << e }
    # Add Right Moves
    right&.each { |e| moves << e }
    moves
  end

  def left_moves
    board_range = (0..7)
    moves = []
    [[-2, -1], [-1, -2], [1, -2], [2, -1]].each do |y, x|
      next unless board_range.include?(@pos[0] + y) && board_range.include?(@pos[1] + x)
      next unless @board[@pos[0] + y][@pos[1] + x].nil? || @board[@pos[0] + y][@pos[1] + x].color == 'black'

      moves << [@pos[0] + y,
                @pos[1] + x]
    end
    moves
  end

  def right_moves
    board_range = (0..7)
    moves = []
    [[-2, 1], [-1, 2], [1, 2], [2, 1]].each do |y, x|
      next unless board_range.include?(@pos[0] + y) && board_range.include?(@pos[1] + x)
      next unless @board[@pos[0] + y][@pos[1] + x].nil? || @board[@pos[0] + y][@pos[1] + x].color == 'black'

      moves << [@pos[0] + y,
                @pos[1] + x]
    end
    moves
  end
end

# 1 - row, 2 - spot
# 2 - row, 1 - spot
# 2 - row, 1 + spot
# 1 - row, 2 + spot
# 1 + row, 2 - spot
# 2 + row, 1 - spot
# 2 + row, 1 + spot
# 1 + row, 2 + spot
