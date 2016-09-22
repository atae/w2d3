require_relative 'deck'

class Hand
  attr_accessor :cards
  def initialize(cards)
    @cards = cards
  end

  def size
    @cards.size
  end

  def score
    points = 0
    points += 6 if flush?
    points += 5 if straight?
    points += of_a_kind? if of_a_kind?
    points + high_card
  end

  def flush?
    counter = Hash.new(0)
    @cards.each do |card|
      counter[card.suit] += 1
    end
    counter.max_by { |k, v| v }[1] == 5
  end

  def straight?
    values = []
    @cards.each do |card|
      values << card.value
    end
    values.sort!
    is_straight = true
    (0...values.size-1).each do |i|
      is_straight = false unless values[i+1] == values[i] + 1
    end
    is_straight
  end

  def of_a_kind?
    counter = Hash.new(0)
    @cards.each do |card|
      counter[card.value] += 1
    end
    big = counter.max_by {|k,v| v}
    counter.delete(big[0])
    big = big[1]
    small = counter.max_by {|k,v| v}[1]

    return 8 if big == 4
    return 7 if big == 3 && small == 2
    return 3 if big == 3 && small < 2
    return 2 if big == 2 && small == 2
    return 1 if big == 2 && small < 2
    false
  end

  def high_card
    values = []
    @cards.each do |card|
      values << card.value
    end
    values.sort.last / 100.0
  end

  def to_s
    str = ""
    @cards.each do |card|
      str += "#{card.to_s} "
    end
    str
  end

end
