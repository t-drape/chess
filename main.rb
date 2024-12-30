# frozen_string_literal: true

require 'yaml'

require_relative('./lib/chess')

if Dir.exist?('chess_games')
  puts 'Would you like to continue an old game? [Y/N]'
  answer = gets.chomp.downcase
  if answer == 'y'
    puts 'Which game would you like to continue?'
    puts Dir.children('chess_games')
    choice = gets.chomp
    filename = "chess_games/#{choice}"
    File.open(filename) do |file|
      game = YAML.unsafe_load(file)
      game.play_game
    end
  else
    Game.new.play_game
  end
else
  Game.new.play_game
end
