class Integer
  def prime?
    self < 2 ? is_prime = false : is_prime = true
    return false if not is_prime

    (2..Math.sqrt(self)).each {|i| is_prime = false if self % i == 0}
    return is_prime
  end
end


class Integer
  def prime_factors
          number = self.abs
    factors = []

    2.upto self.abs do |x| while x.prime? and number % x == 0
              factors.push x
              number /= x
      end
    end

    return factors
  end
end


class Integer
  def harmonic
    sum = 0
    (1..self).each {|x| sum += Rational(1,x)}
    return sum
  end
end


class Integer
  def digits
    number = self.abs
    digits_array = []

    while number > 0
      digits_array.push(number % 10)
      number /= 10
    end

    return digits_array.reverse
  end
end


class Array
  def frequencies
    freq = {}
    self.each {|i| freq.has_key?(i) ? freq[i] += 1 : freq[i] = 1}
    return freq
  end
end


class Array
  def average
    sum = 0.0
    self.each {|i| sum += i}
    return sum / self.size
  end
end


class Array
  def drop_every(n)
    filtered = []
    count = 1

    self.each do |x|
      filtered.push(x) if count != n
      count < n ? count += 1 : count = 1
    end

    return filtered
  end
end


class Array
  def combine_with(other)
    one = self
    combined = []

    while  one.any? or other.any?
      combined.push one.shift unless one.empty?
      combined.push other.shift unless other.empty?
    end

    return combined
  end
end