require_relative 'hand'

class Player
  attr_accessor :hand, :bankroll, :fold, :index
  def initialize(index)
    @index = index
    @fold = false
    @hand = nil
    @bankroll = 100
  end

  def action
    puts "Fold, call, or raise? (f, c, raise_amt)"
    input = gets.chomp
  end

  def discard
    puts "Which cards would you like to discard? (1,3)"
    cards = gets.chomp.split(",")
  end

  def render
    puts "Player #{@index}: #{@hand.to_s}"
  end


end
