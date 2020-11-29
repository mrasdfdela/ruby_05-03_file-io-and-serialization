require 'byebug'

class Hangman
  attr_reader :player, :board, :secret_word
  def initialize
    @player = Player.new
    @board = Board.new
  end

  def play_game
    'Let\'s play a game'
    until @board.incorrect_count == 6 || @board.word_guessed
      guess = player.get_guess
      board.eval_guess(guess)
    end
    if @board.word_guessed
      puts "Congratulation! You have won!"
    else
      puts "Sorry, you have run out of guesses. =("
    end
    byebug
  end
end

class Player
  attr_reader :name, :guessed_letters
  def initialize
    @name = get_name
    @guessed_letters = []
  end

  def get_name
    puts "Welcome! What is your name?"
    gets.chomp
  end

  def get_guess
    puts "Please guess a letter:"
    guess = gets.chomp
  end
end

class Board
  attr_reader :word_bank, :secret_word, :board_letters, :incorrect_count, :guesses
  def initialize
    @word_bank = parse_word_bank
    @secret_word = select_secret_word(@word_bank, 5,12)
    @board_letters = populate_board(@secret_word)
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
    word
  end

  def populate_board(secret_word)
    empty_phrase = []
    secret_word.length.times do
      empty_phrase << "_"
    end
    empty_phrase
  end

  def word_guessed
    @secret_word == @board_letters
  end

  def eval_guess(letter)
    @incorrect_count += 1
    puts @incorrect_count
  end
end

game = Hangman.new
game.play_game