require_relative 'card'

class Deck
  attr_accessor :deck

  def initialize
    @deck = build_deck
  end

  def build_deck
    values = (2..14).to_a
    suits = %w(Spades Clubs Diamonds Hearts)
    @deck = []

    suits.each do |suit|
      values.each do |value|
        @deck << Card.new(value, suit)
      end
    end
    shuffle
  end

  def shuffle
    @deck.shuffle
  end
end
