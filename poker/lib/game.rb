require_relative 'player'

class Game
  attr_accessor :players, :current_player, :current_bet, :pot

  def initialize
    @players = create_players
    @current_player = @players.first
    @current_bet = 0
    @dealer_idx = 0
    @pot = 0
  end

  def bet
    log = ""
    current_idx = @dealer_idx
    until log == "ccccc" || /[[:digit:]][[:alpha:]][[:alpha:]][[:alpha:]][[:alpha:]]/.match(log[-5..-1])
      current_idx = 0 if current_idx == 5
      input = @players[current_idx].action
      log += input

      if input == "f"
        fold
      elsif input == "c"
        call
      else
        call_and_raise(input.to_i)
      end

      current_idx += 1
    end
  end

  def call
    @current_player.bankroll -= @current_bet
    @pot += @current_bet
  end

  def create_players
    players = []
    (0..4).each do |i|
      players << Player.new(i)
    end
    players
  end

  def deal
    @players.each do |player|
      cards = []

      5.times do
        cards << @d.deck.shift
      end

      player.hand = Hand.new(cards)
    end
  end

  def discard
    @players.each do |player|
      discard_cards(player.index, player.discard) unless player.fold
    end
  end

  def discard_cards(player_idx, card_idx)
    card_idx.each do |idx|
      @players[player_idx].hand.cards.delete_at(idx)
    end

    until @players[player_idx].hand.size == 5
      @players[player_idx].hand.cards << @d.deck.shift
    end
  end

  def fold
    @current_player.fold = true
  end

  def play
    until win?
      @d = Deck.new
      deal
      render
      bet
      discard
      bet
      unfold_players
      @dealer_idx += 1
      @dealer_idx = 0 if @dealer_idx == 5
    end
  end

  def call_and_raise(raise_amt)
    @current_bet += raise_amt
    call
  end

  def render
    @players.each do |player|
      player.render
    end
  end

  def round_win?

  end

  def swap_turn
    next_player = nil
    current_idx = @current_player.index

    while next_player == nil
      current_idx = 0 if current_idx == 5

      if @players[current_idx + 1].fold == true
        current_idx += 1
      else
        next_player = @players[current_idx + 1]
      end
    end
    @current_player = next_player
  end

  def unfold_players
    @players.each do |player|
      player.fold = false
    end
  end

  def win?
    counter = 0
    @players.each do |player|
      counter += 1 if player.bankroll <= 0
    end
    counter == 4

  end
end

if __FILE__ == $PROGRAM_NAME
  g = Game.new
  g.play

end
