require 'byebug'
require 'yaml'

class Hangman
  attr_reader :player, :board, :guessed_letters, :saved_directory
  def initialize
    @board = Board.new
    @guessed_letters = []
    @saved_directory = 'saved_directory.txt'
  end

  def play_game
    start_game
    until @board.incorrect_count == 6 || @board.word_guessed
      board.print_board
      guess = get_guess

      if guess == 'save'
        save_game
        break
      else
        @guessed_letters << guess
        board.eval_guess(guess)
      end
    end
    end_game
  end

  def start_game
    puts "Let\'s play hangman!"
    puts "Enter 'n' to start a new game or 'l' to load a game:"
    entry = ''
    until entry == 'l' || entry == 'n'
      entry = gets.downcase.chomp
    end
    entry == 'l' ? load_game : @player = get_name
  end

  def load_game
    puts "Select from the list of saved games:"
    File.open(saved_directory, 'r').readlines.each { |line| puts line }

    file = ''
    until File.exists?("#{file}.yml")
      puts "Enter the game name:"
      file = gets.chomp
    end
    s = YAML.load(File.read("#{file}.yml"))

    @player = s.player
    @guessed_letters = s.guessed_letters
    @board = s.board
  end

  def end_game
    if @board.word_guessed
      puts "Congratulation, #{@player}! You have won!"
    elsif @board.incorrect_count == 6
      puts "Sorry, #{@player}, you have run out of guesses. =("
    else 
      puts 'Game saved!'
    end
  end

  def get_name
    puts 'Welcome! What is your name?'
    gets.chomp
  end

  def get_guess
    msg = "Please guess a letter, or enter 'save':"
    g = ''

    until g.length == 1 && g.between?('a', 'z') && !@guessed_letters.include?(g) || g == 'save'
      p msg
      g = gets.chomp.downcase
      msg = "\nInvalid selection. Please guess again:"
    end
    g
  end

  def save_game
    # p = @player
    # t = Time.now.strftime("%Y%m%d_%H%M%S")
    # save_file = File.open("#{p}_#{t}.yml", 'w') {|file|
    #   file.write(self.to_yaml)
    # }

    # file = 'saved_games.yaml'
    # Dir.mkdir file unless File.exists?('saved_games.yml') { |file|
    #   file.(self.to_yaml)
    # }

    save_file = ''
    save_file = gets.chomp
    File.open("#{save_file}.yml", 'w') { |file|
      file.write(self.to_yaml)
    }

    d = @saved_directory
    File.open(d,'w') unless File.exists?(d)
    File.open(d, 'a') {|file|
      file.puts save_file
    }
  end
end

class Board
  attr_reader :word_bank, :secret_word, :board_guesses, :incorrect_count, :guesses
  def initialize
    # @word_bank = parse_word_bank
    @secret_word = select_secret_word(parse_word_bank, 5,12)
    @board_guesses = populate_board(@secret_word)
    @incorrect_count = 0
    @guesses = []
  end

  def parse_word_bank
    file = File.open('5desk.txt')
    word_bank = []
    while !file.eof?
      word_bank << file.readline
    end
    word_bank
  end

  def select_secret_word(word_bank, min, max)
    word = ''
    until word.length >= 5 && word.length <= 12
      word = word_bank.sample.chomp
    end
    word.split('')
  end

  def populate_board(secret_word)
    empty_phrase = []
    secret_word.length.times do
      empty_phrase << "_"
    end
    empty_phrase
  end

  def word_guessed
    @secret_word == @board_guesses
  end

  def eval_guess(letter)
    correct_guess = false
    @secret_word.each_with_index do |el, idx|
      if el == letter
        @board_guesses[idx] = letter
        correct_guess = true
      end
    end
    @guesses << letter
    @incorrect_count += 1 if correct_guess == false
  end

  def print_board
    puts "Secret word: #{secret_word.join('')}"
    puts "Word: #{@board_guesses}"
    puts "Guesses: #{@guesses}"
    puts "Incorrect count: #{incorrect_count}"
  end
end

game = Hangman.new
game.play_game