# frozen_string_literal: true

# Find all moves for a black rook except castling
module BlackRookMovement
  def normal_moves
    moves = []
    vertical = vertical_moves
    horizontal = horizontal_moves
    vertical.each { |e| moves << e } unless vertical.empty?
    horizontal.each { |e| moves << e } unless horizontal.empty?
    moves
  end

  def vertical_moves
    moves = []
    less = up_to_pos_zero_moves
    more = from_pos_zero_moves
    less.each { |e| moves << e } unless less.empty?
    more.each { |e| moves << e } unless more.empty?
    moves
  end

  def up_to_pos_zero_moves # rubocop:disable Metrics/AbcSize
    moves = []
    y = @pos[0]
    while y.positive?
      y -= 1
      break if !@board[y][@pos[1]].nil? && @board[y][@pos[1]].color == @color

      moves << [y, @pos[1]]
      break unless @board[y][@pos[1]].nil?
    end
    moves
  end

  def from_pos_zero_moves # rubocop:disable Metrics/AbcSize
    moves = []
    y = @pos[0]
    while y < 7
      y += 1
      break if !board[y][@pos[1]].nil? && @board[y][@pos[1]].color == @color

      moves << [y, @pos[1]]
      break unless @board[y][@pos[1]].nil?
    end
    moves
  end

  def horizontal_moves
    moves = []
    less = up_to_pos_one_moves
    more = from_pos_one_moves
    less.each { |e| moves << e } unless less.empty?
    more.each { |e| moves << e } unless more.empty?
    moves
  end

  def up_to_pos_one_moves
    moves = []
    x = @pos[1]
    while x.positive?
      x -= 1
      break if @board[@pos[0]][x] && @board[@pos[0]][x].color == @color

      moves << [@pos[0], x]
      break unless @board[@pos[0]][x].nil?
    end
    moves
  end

  def from_pos_one_moves
    moves = []
    x = @pos[1]
    while x < 7
      x += 1
      break if @board[@pos[0]][x] && @board[@pos[0]][x].color == @color

      moves << [@pos[0], x]
      break unless @board[@pos[0]][x].nil?
    end
    moves
  end
end

# Find all moves for a white rook except castling
module WhiteRookMovement
  def normal_moves
    moves = []
    vertical = vertical_moves
    horizontal = horizontal_moves
    vertical.each { |e| moves << e } unless vertical.empty?
    horizontal.each { |e| moves << e } unless horizontal.empty?
    moves
  end

  def vertical_moves
    moves = []
    less = up_to_pos_zero_moves
    more = from_pos_zero_moves
    less.each { |e| moves << e } unless less.empty?
    more.each { |e| moves << e } unless more.empty?
    moves
  end

  def up_to_pos_zero_moves # rubocop:disable Metrics/AbcSize
    moves = []
    y = @pos[0]
    while y.positive?
      y -= 1
      break if !@board[y][@pos[1]].nil? && @board[y][@pos[1]].color == @color

      moves << [y, @pos[1]]
      break unless @board[y][@pos[1]].nil?
    end
    moves
  end

  def from_pos_zero_moves # rubocop:disable Metrics/AbcSize
    moves = []
    y = @pos[0]
    while y < 7
      y += 1
      break if !board[y][@pos[1]].nil? && @board[y][@pos[1]].color == @color

      moves << [y, @pos[1]]
      break unless @board[y][@pos[1]].nil?
    end
    moves
  end

  def horizontal_moves
    moves = []
    less = up_to_pos_one_moves
    more = from_pos_one_moves
    less.each { |e| moves << e } unless less.empty?
    more.each { |e| moves << e } unless more.empty?
    moves
  end

  def up_to_pos_one_moves
    moves = []
    x = @pos[1]
    while x.positive?
      x -= 1
      break if @board[@pos[0]][x] && @board[@pos[0]][x].color == @color

      moves << [@pos[0], x]
      break unless @board[@pos[0]][x].nil?
    end
    moves
  end

  def from_pos_one_moves
    moves = []
    x = @pos[1]
    while x < 7
      x += 1
      break if @board[@pos[0]][x] && @board[@pos[0]][x].color == @color

      moves << [@pos[0], x]
      break unless @board[@pos[0]][x].nil?
    end
    moves
  end
end
