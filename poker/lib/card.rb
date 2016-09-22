class Card
  attr_reader :value, :suit, :color
  def initialize(value,suit)
    @value = value
    @suit = suit
    @color = get_color
  end

  def get_color
    @suit == "Diamonds" || @suit == "Hearts" ? "Red" : "Black"
  end

  def to_s
    "#{@value > 10 ? get_value : @value}|#{@suit[0]}" 
  end

  def get_value
    %w(J Q K A)[@value-11]
  end

  def <=>(other)
    @value <=> other.value
  end

end
