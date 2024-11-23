class Game
  def initialize
    @player_one = 'white'
    @player_two = 'black'
    @current_player = @player_one
    @winner = nil
    @board = {
      one: ["\u265C", "\u265E", "\u265D", "\u265B", "\u265A", "\u265D", "\u265E", "\u265C"],
      two: ["\u265F", "\u265F", "\u265F", "\u265F", "\u265F", "\u265F", "\u265F", "\u265F"],
      three: [],
      four: [],
      five: [],
      six: [],
      seven: ["\u2659", "\u2659", "\u2659", "\u2659", "\u2659", "\u2659", "\u2659", "\u2659"],
      eight: ["\u2656", "\u2658", "\u2657", "\u2655", "\u2654", "\u2657", "\u2658", "\u2656"]
    }
  end

  def show_board
    @board.each_value do |index|
      p index
    end
  end
end
x = Game.new
x.show_board
