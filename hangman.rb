require 'byebug'

class Hangman
  attr_reader :player, :board, :secret_word
  def initialize
    puts 'hello hangman world!'
    @player = Player.new
    @board = Board.new
  end
end

class Player
  def initialize
    puts 'hello playa'
  end
end

class Board
  attr_reader :word_bank, :secret_word
  def initialize
    puts 'bored? or board'
    @word_bank = parse_word_bank
    @secret_word = select_secret_word(@word_bank, 5,12)
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
end
game = Hangman.new

byebug
puts game