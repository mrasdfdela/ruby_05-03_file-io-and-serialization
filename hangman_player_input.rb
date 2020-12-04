def player_name
  puts 'Welcome! What is your name?'
  gets.chomp
end

def player_guess
  msg = "Please guess a letter, or enter 'save':"
  g = ''

  until g.length == 1 && g.between?('a', 'z') && !@guessed_letters.include?(g) || g == 'save'
    p msg
    g = gets.chomp.downcase
    msg = "Invalid selection. Please guess again:"
  end
  g
end