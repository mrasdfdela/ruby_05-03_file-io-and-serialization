require 'byebug'

class Hangman
  attr_reader :player, :board, :secret_word
  def initialize
    @player = Player.new
    @board = Board.new
  end

  def play_game
    puts 'Let\'s play a game'
    until @board.incorrect_count == 6 || @board.word_guessed
      board.print_board
      guess = player.get_guess
      board.eval_guess(guess)
    end
    end_of_game
    byebug
  end

  def end_of_game
    if @board.word_guessed
      puts "Congratulation! You have won!"
    else
      puts "Sorry, you have run out of guesses. =("
    end
  end
end

class Player
  attr_reader :name, :guessed_letters
  def initialize
    @name = get_name
    @guessed_letters = []
  end

  def get_name
    puts 'Welcome! What is your name?'
    gets.chomp
  end

  def get_guess
    msg = 'Please guess a letter:'
    g = ''
    until g.length == 1 && g.between?('a', 'z') && !guessed_letters.include?(g)
      p msg
      g = gets.chomp.downcase
      msg = "\nInvalid selection. Please guess again:"
    end
    @guessed_letters << g
    g
  end
end

class Board
  attr_reader :word_bank, :secret_word, :board_guesses, :incorrect_count, :guesses
  def initialize
    @word_bank = parse_word_bank
    @secret_word = select_secret_word(@word_bank, 5,12)
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