require 'byebug'
require 'yaml'
require_relative 'hangman_load'
require_relative 'hangman_save'
require_relative 'hangman_player_input'

class Hangman
  attr_reader :save_file, :saved_games, :save_index
  attr_accessor :player, :guessed_letters, :board
  def initialize(new_game = true, idx = nil)
    @save_file = 'saved_games.yml'
    if new_game
      load_saved_games
      @save_index = nil
    else
      @save_index = idx
      @player = nil
      @guessed_letters = []
      @board = Board.new(false)
    end
  end

  def play_game
    start_game
    until @board.incorrect_count == 6 || @board.word_guessed
      board.print_board
      guess = player_guess

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

    arr = saved_games_idx
    if arr.length.positive?
      puts 'Would you like to start a new game or load a saved game?'
      entry = ''
      until %w(l n).include?(entry)
        entry = gets[0].downcase.chomp
      end
      entry == 'l' ? load_game(arr) : new_game
    else
      new_game
    end
  end

  def new_game
    @board = Board.new
    @guessed_letters = []
    @player = player_name
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
end

class Board
  attr_reader :word_bank, :secret_word, :board_guesses, :incorrect_count, :guesses
  def initialize(new_game = true)
    if new_game
      @secret_word = select_secret_word(parse_word_bank, 5,12)
      @board_guesses = populate_board(@secret_word)
      @incorrect_count = 0
      @guesses = []
    else
      @secret_word = []
      @board_guesses = []
      @incorrect_count = 0
      @guesses = []
    end
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
      word = word_bank.sample.downcase.chomp
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
    # puts "Secret word: #{secret_word.join('')}"
    puts "Word: #{@board_guesses}"
    puts "Incorrect count: #{incorrect_count}"
    puts "Guesses: #{@guesses}"
  end
end

game = Hangman.new
game.play_game
# For populating the initial save file
# Hangman.populate_save_file