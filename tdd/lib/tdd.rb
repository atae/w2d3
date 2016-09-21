class Array
  def my_uniq
    array = []
    self.each do |el|
      array << el unless array.include?(el)
    end
    array
  end

  def two_sum
    pairs = []
    idx = 0
    until idx == self.length
      idx2 = idx + 1
      until idx2 == self.length
        pairs << [idx, idx2] if self[idx] + self[idx2] == 0
        idx2 += 1
      end
      idx += 1
    end
    pairs
  end
end

def my_transpose(original_array)
  array = []
  original_array.each_index do |i|
    sub_array = []
    original_array[i].each_index do |j|
      sub_array << original_array[j][i]
    end
    array << sub_array
  end
  array
end

def stock_picker(array)
  best_day = [0,1]
  (0...array.size-1).each do |i|
    (i+1...array.size).each do |j|
      profit = array[j] - array[i]
      best_day = [i,j] if array[best_day[1]] - array[best_day[0]] < profit
    end
  end

  best_day
end

def towers_of_hanoi(moves)
  $PILE = [[3,2,1],[],[]]

  until won?
    begin
      p $PILE
      move(moves)
    rescue
      puts "Invalid move"
      retry
    end
  end

  $PILE[2]
end

def won?
  $PILE[0].empty? && $PILE[1].empty? && $PILE[2] == [3,2,1]
end

def move(moves)
  #puts "Select"
  sel = moves.shift
  #puts "Place"
  place = moves.shift

  if $PILE[place].empty? || $PILE[sel].last < $PILE[place].last
    $PILE[place] << $PILE[sel].pop
  else
    raise "Invalid move"
  end

end
