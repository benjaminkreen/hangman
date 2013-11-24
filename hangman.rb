## Hangman from from the ground up with a little peaking at my old code
# Added some comments for kicks


class HangMan
  
  attr_accessor :progress :knower :guesser
  
  def initialize
    @knower = nil
    @guesser = nil
    @progress = []
  end
  
  def won?
    @progress == @knower.secret
  end
  
  def run
    puts "Welcome to Hang Man"
    puts "This is the github version"
    puts "So far you can only be a guesser, so please enter that"
    puts "Would you like to be a knower or guesser?"
    user_input = gets.chomp
    if user_input == "guesser"
      @knower = ComputerPlayer.new
      @guesser = HumanPlayer.new
    else
      puts "Bad Input, exiting."
      return
    end
    play
  end
  
  def play
    @progress = Array.new(@knower.secret.length) {'_'}
    until won?
      puts @progress.join(' ')
      guess = @guesser.get_guess
      @progress = @knower.update_progress(guess, @progress)
    end
    puts @progress.join(' ')
    puts "congrats!"
  end
  
  
end

class HumanPlayer
  
end

class ComputerPlayer
  
end

class Dictionary
  
end