require 'rspec'
require 'tdd'

describe "my_uniq" do
  it "removes duplicates" do
    expect([1,2,1,3,3].my_uniq).to eq([1,2,3])
  end
end

describe "two_sum" do
  it "returns positions that sum to zero" do
    expect([-1, 0, 2, -2, 1].two_sum).to eq([[0, 4], [2, 3]])
  end
end

describe "my_transpose" do
  it "transposes array" do
    expect(my_transpose([[0, 1, 2],[3, 4, 5],[6, 7, 8]])).to eq([[0, 3, 6],[1, 4, 7],[2, 5, 8]])
  end
end

describe "stock_picker" do
  it "returns most profitable pair" do
    expect(stock_picker([4,6,7,2,9,9,3,6])).to eq([3,4])
  end
end

describe "towers_of_hanoi" do
  moves = [0,2,0,1,2,1,0,2,1,0,1,2,0,2]

  it "runs game properly" do
    expect(towers_of_hanoi(moves)).to eq(([3,2,1]).to_a)
  end
end
