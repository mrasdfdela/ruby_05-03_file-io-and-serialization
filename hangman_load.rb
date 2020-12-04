# loads and uses saved_games.yml to instance var
def load_saved_games
  file = @save_file
  @saved_games = YAML.load_stream(File.open(file))
end

# for loading saved games
def saved_games_idx
  saved_idxs = []
  @saved_games.each do |g|
    saved_idxs << g.save_index unless g.player == nil
  end
  saved_idxs
end

def load_game(arr)
  idx = ''
  msg = ''

  until arr.include?(idx)
    p "#{msg}"
    print_saved_games('Select from one of the saved games:')
    idx = gets[0].to_i
    msg = 'Invalid selection. '
  end
  g = @saved_games[idx]

  @player = g.player
  @guessed_letters = g.guessed_letters
  @board = g.board
end

def print_saved_games(msg)
  # unless @saved_games.all? { |g| g.player.nil? }
    p msg
    @saved_games.each do |game|
      puts "#{game.save_index} (#{game.player})" unless game.player.nil?
    end
  # end
end