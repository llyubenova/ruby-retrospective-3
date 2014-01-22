class Integer
  def prime?
    return false if self < 2
    (2..Math.sqrt(self)).all? {|i| remainder(i).nonzero?}
  end

  def prime_factors
    factors, number = [], self.abs
    (2..number).select(&:prime?).each do |factor|
      while number.remainder(factor).zero?
        factors.push factor
        number /= factor
      end
    end
    factors
  end

  def harmonic
    (1..self).reduce {|sum, i| sum + 1 / i.to_r}
  end

  def digits
    abs.to_s.chars.map(&:to_i)
  end
end

class Array
  def frequencies
    frequencies = {}
    self.each {|item| frequencies[item] = self.count(item)}
    frequencies
  end

  def average
    reduce(:+) / self.count.to_f
  end

  def drop_every(n)
    self.each_with_index.select {|item, index| item unless (index + 1) % n == 0}.map(&:first)
  end

  def combine_with(other)
    min_length = [self.length, other.length].min
    combined = self.take(min_length).zip(other.take(min_length))
    combined << self.drop(min_length) << other.drop(min_length)
    combined.flatten(1)
  end
end