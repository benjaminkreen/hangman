require 'Set'

class Hangman
  attr_accessor :knower, :guesser, :progress

  def initialize
    @knower, @guesser = nil, nil
    @progress = []
  end

  def run
    puts "Welcome to Hangman!"
    puts "Would you like to be the knower or the guesser?"
    puts "Or type \"computer\" if you would like a computer vs. computer game,"
    puts "Or type \"human\" if you would like a human vs. human game."
    determine_players
    start_game
  end

  def determine_players
    input = gets.downcase.chomp

    case input
    when "knower"
      @knower = HumanPlayer.new("knower")
      @guesser = ComputerPlayer.new("guesser")
    when "guesser"
      @knower = ComputerPlayer.new("knower")
      @guesser = HumanPlayer.new("guesser")
    when "computer"
      @knower = ComputerPlayer.new("knower")
      @guesser = ComputerPlayer.new("guesser")
    when "human"
      @knower = HumanPlayer.new("knower")
      @guesser = HumanPlayer.new("guesser")
    else
      puts "Invalid command!  Exiting."
      return
    end
  end

  def start_game
    @progress = @knower.determine_word
    puts @progress.join(" ")

    until win?
      guess = @guesser.guess_letter(@progress)
      @progress = @knower.judge_letter(guess, @progress)
      puts @progress.join(" ")
    end

    puts "Congratulations!"
  end

  def win?
    !@progress.include?("_")
  end

end

class ComputerPlayer
  attr_accessor :secret_word, :mode, :ltr_pool, :used_letters

  def initialize(mode)
    @mode = mode
    @secret_word = ''
    @ltr_pool = []
    @used_letters = []
  end

  def guess_letter(progress)
    possible_words = remake_word_pool(progress)
    remake_letter_pool(possible_words)
    letter = @ltr_pool.pop
    used_letters << letter
    letter
  end

  def remake_word_pool(progress)
    regexp = "^#{progress.join.gsub(/_/,'\w')}$"

    possible_words = []
    dictionary = Dictionary.new.dictionary_array

    dictionary.each do |word|
      possible_words << word if word.match(regexp)
    end

    #p possible_words
    possible_words
  end

  def remake_letter_pool(possible_words)
    char_array = possible_words.join.split('')
    pairs_array = []

    count_hash = Hash.new(0)

    char_array.each do |char|
      count_hash[char] += 1
    end

    count_hash.each_pair do |key, value|
      pairs_array << [value, key] if value > 0
    end

    pairs_array.sort!.each do |pair|
      @ltr_pool << pair[1]
    end
    @ltr_pool -= @used_letters
  end

  def determine_word
    @secret_word = Dictionary.new.random_word
    Array.new(@secret_word.length) { "_" }
  end

  def judge_letter(ltr, progress)
    @secret_word.split('').each_with_index do |secret_ltr, index|
      progress[index] = ltr if ltr == secret_ltr
    end
    progress
  end

end

class HumanPlayer
  attr_accessor :secret_word, :mode

  def initialize(mode)
    @mode = mode
    @secret_word = ''
  end

  def judge_letter(letter, progress)
    puts "What are the indecies for #{letter.upcase}?"
    puts "Enter indices as such: \"0 3\""
    puts "Enter \"none\" if letter not present."
    input = gets.chomp
    return progress if input == "none"
    input.split(' ').each do |i|
      progress[i.to_i] = letter
    end
    progress
  end


  def guess_letter(progress)
    puts "Guess one letter!"
    gets.chomp.downcase
  end

  def determine_word
    puts "Please enter your word length"
    length = Integer(gets.chomp)
    Array.new(length) { "_" }
  end
end

class Dictionary
  attr_accessor :dictionary_array

  def initialize
    @dictionary_array = []
    File.readlines('./dictionary.txt').each do |line|
      @dictionary_array << line.chomp
    end
  end

  def random_word
    candidate = ''
    until candidate.match(/^(\w)+$/) do
      candidate = @dictionary_array.sample
    end
    candidate
  end
end

h = Hangman.new
h.run
