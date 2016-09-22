require "rspec"
require "card"
require "deck"
require "hand"
require "player"
require "game"
require "byebug"

describe "card" do
  before(:each) do
    @c = Card.new(5,'Hearts')
  end

  describe "#initialize" do
    it "initializes correctly" do
      expect(@c.value).to eq(5)
      expect(@c.suit).to eq('Hearts')
      expect(@c.color).to eq('Red')
    end
  end
end

describe "deck" do
  before(:each) do
    @d = Deck.new
  end
  describe "#initialize" do
    it "has 52 cards" do
      expect(@d.deck.size).to eq(52)
    end

    it "has card objects" do
      expect(@d.deck.first.class).to eq(Card)
    end

    it "shuffles" do
      expect(@d).to receive(:shuffle)
      @d.shuffle
    end

  end
end

describe "hand" do

  describe "#initialize" do
    let (:card1) {instance_double("Card", :value => '5', :suit => 'Heart', :color => 'Red')}
    let (:card2) {instance_double("Card", :value => '5', :suit => 'Diamond', :color => 'Red')}
    let (:card3) {instance_double("Card", :value => '5', :suit => 'Spades', :color => 'Black')}
    let (:card4) {instance_double("Card", :value => '5', :suit => 'Club', :color => 'Black')}
    let (:card5) {instance_double("Card", :value => '6', :suit => 'Heart', :color => 'Red')}

    h = Hand.new([:card1, :card2, :card3, :card4, :card5])
    it "has 5 cards" do
      expect(h.size).to eq(5)
    end
  end

  describe "#score" do

    let (:card1) {double("Card", :value => 5, :suit => 'Heart', :color => 'Red')}
    let (:card2) {double("Card", :value => 5, :suit => 'Diamond', :color => 'Red')}
    let (:card3) {double("Card", :value => 5, :suit => 'Spades', :color => 'Black')}
    let (:card4) {double("Card", :value => 5, :suit => 'Club', :color => 'Black')}
    let (:card5) {double("Card", :value => 6, :suit => 'Club', :color => 'Black')}
    let (:card6) {double("Card", :value => 7, :suit => 'Heart', :color => 'Red')}
    let (:card7) {double("Card", :value => 8, :suit => 'Heart', :color => 'Red')}
    let (:card8) {double("Card", :value => 9, :suit => 'Heart', :color => 'Red')}
    let (:card9) {double("Card", :value => 10, :suit => 'Heart', :color => 'Red')}
    let (:card10) {double("Card", :value => 6, :suit => 'Diamond', :color => 'Red')}
    let (:card11) {double("Card", :value => 6, :suit => 'Spades', :color => 'Black')}
    let (:card12) {double("Card", :value => 12, :suit => 'Heart', :color => 'Red')}
    let (:card13) {double("Card", :value => 12, :suit => 'Diamond', :color => 'Red')}

    context "flush" do
      it "scores flush" do
        flush = Hand.new([card6, card7, card8, card9, card12])
        expect(flush.score).to be_within(0.14).of(6)
      end
    end

    context "straight" do
      it "scores straight" do
        straight = Hand.new([card6, card7, card8, card9, card10])
        expect(straight.score).to be_within(0.14).of(5)
      end
    end

    context "of a kind" do
      it "scores four of a kind" do
        four_of_a_kind = Hand.new([card1, card2, card3, card4, card5])
        expect(four_of_a_kind.score).to be_within(0.14).of(8)
      end

      it "scores full house" do
        full_house = Hand.new([card1, card2, card3, card5, card11])
        expect(full_house.score).to be_within(0.14).of(7)
      end

      it "scores three of a kind" do
        three_of_a_kind = Hand.new([card1, card2, card3, card7, card9])
        expect(three_of_a_kind.score).to be_within(0.14).of(3)
      end

      it "scores two pair" do
        two_pair = Hand.new([card1, card2, card5, card11, card7])
        expect(two_pair.score).to be_within(0.14).of(2)
      end

      it "scores one pair" do
        one_pair = Hand.new([card1, card2, card5, card7, card8])
        expect(one_pair.score).to be_within(0.14).of(1)
      end
    end

    context "high card" do
      it "scores high card" do
        high_card = Hand.new([card6, card7, card8, card9, card13])
        expect(high_card.score).to eq(0.12)
      end
    end
  end
end

describe "player" do
end

describe "game" do
  before(:each) do
    @g = Game.new
    @g.play
  end

  describe "#initialize" do

    it "creates players" do
      expect(@g.players.size).to eq(5)
    end
  end

  describe "#deal" do

    it "deals cards to players" do
      @g.play
      @g.deal
      @g.players.each do |player|
        expect(player.hand.size).to eq(5)
      end
    end


  end

  describe "#fold" do
    it "player folds" do
      @g.fold
      expect(@g.current_player.fold).to eq(true)
    end
  end

  describe "#call" do
    it "takes money from player's bankroll and adds it to the pot" do
      old_pot = @g.pot
      old_bankroll = @g.current_player.bankroll
      @g.call
      expect(@g.pot).to be > old_pot
      expect(old_bankroll).to be > @g.current_player.bankroll
    end

  end

  describe "#raise" do
    it "increases the pot" do
      old_pot = @g.pot
      old_bankroll = @g.current_player.bankroll
      @g.call_and_raise(50)
      expect(@g.pot).to be > old_pot
      expect(old_bankroll).to be > @g.current_player.bankroll
    end

    it "increases the current bet" do
      old_bet = @g.current_bet
      @g.call_and_raise(50)
      expect(@g.current_bet).to eq(old_bet + 50)
    end
  end

  describe "#discard" do
    it "removes cards from current player's hand and gives them new ones" do
      @g.deal
      old_hand = @g.current_player.hand.dup
      @g.discard([0,3])
      expect(@g.current_player.hand).not_to eq(old_hand)
    end
  end

  describe "#swap_turn" do
    it "skips turn if player folded and goes to next player" do
      #when intiaizling, intialize player 2 as already folded
      @g.players[1].fold = true
      @g.swap_turn
      expect(@g.current_player.index).to eq(2)
    end

  end

  describe "win?" do
    it "returns true if everyone else has no money" do
      (1..4).each do |i|
        @g.players[i].bankroll = 0
      end
      expect(@g.win?).to eq(true)
    end
  end


end
