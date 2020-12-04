def save_game
  save_game_dialog
  selection = ''
  until (0..2).include?(selection)
    selection = gets.chomp.to_i
  end

  g = @saved_games[selection]
  g.player = @player
  g.guessed_letters = @guessed_letters
  g.board = @board

  File.open(@save_file,'w') do |file|
    3.times do |idx|
      file.write(@saved_games[idx].to_yaml)
    end
  end
end

def save_game_dialog
  msg = 'Select a save slot: 0-2.'
  unless @saved_games.all? { |g| g.player.nil? }
    msg += ' Previously saved games:'
  end
  print_saved_games(msg)
end

def self.populate_save_file
  File.open('saved_games.yml','w') do |file|
    3.times do |idx|
      file.write(self.new(false, idx).to_yaml)
    end
  end
end