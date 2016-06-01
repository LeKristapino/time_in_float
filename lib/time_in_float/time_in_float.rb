class TimeInFloat
  attr_reader :decimal, :type

  TYPES = %i(hours minutes seconds).freeze

  def self.valid?(param)
    big_d = BigDecimal(param.to_s)
    return false if (big_d - big_d.to_i) >= 0.6
    true
  end

  %i(+ -).each do |a|
    define_method a do |other|

      # To do arithmetics both objects have to be TimeInFloat and of the same type
      raise TimeInFloat::ArgumentError, 'can only add TimeInFloat' unless other.is_a?(TimeInFloat)
      raise TimeInFloat::TimeMismatchError, 'both times should be of the same type' unless type == other.type
      sum = BigDecimal.new(0)

      # Get the number after decimal point for self and argument
      dec = decimal - decimal.to_i
      other_dec = other.decimal - other.decimal.to_i

      # Deal with cases where sum of both numbers after decimal is bigger than 0.6
      if dec.send(a, other_dec) >= 0.6 || dec.send(a, other_dec) < 0
        sum = sum.send(a, BigDecimal.new('0.4'))
        sum += decimal.send(a, other.decimal)
      else
        sum = decimal.send(a, other.decimal)
      end

      self.class.new(sum)
    end
  end

  def initialize(decimal = 0, type: :hours, normalize: true)
    raise TimeInFloat::ArgumentError, 'Valid values for type are: :hours, :minutes, :seconds' unless TYPES.include?(type)
    @decimal = decimal.is_a?(BigDecimal) ? decimal : BigDecimal.new(decimal.to_s)
    raise TimeInFloat::NegativeNumberError, 'time can\'t be negative' if @decimal < 0

    if (@decimal - @decimal.to_i) >= 0.6
      # If normalize is not false, deal with input floats that have more than 0.6 after decimal
      # and normalize them e.g. 1.8 would turn into 2.2 (2 units, 20 subunits)
      # Otherwise raise an error
      raise TimeInFloat::ArgumentError, 'should not exceed 0.6 after decimal point ' unless normalize
      normalize_input
    end

    @type = type
  end

  def whole_hours
    case type
    when :hours
      decimal.to_i
    when :minutes
      decimal / 60
    when :seconds
      decimal / 3600
    end
  end

  def whole_minutes
    case type
    when :hours
      res = decimal.to_i * 60 + (decimal - decimal.to_i) * 100
    when :minutes
      res = decimal
    when :seconds
      res = decimal / 60
    end
    res.to_i
  end

  def whole_seconds
    case type
    when :hours
      res = decimal.to_i * 3600 + (decimal - decimal.to_i) * 100 * 60
    when :minutes
      res = decimal.to_i * 60 + (decimal - decimal.to_i) * 100
    when :seconds
      res = decimal
    end
    res.to_i
  end

  def to_f
    decimal.to_f
  end

  private

  def normalize_input
    # Adding 0.4 to numbers with decimals bigger than 0.6 normalizes them
    @decimal += BigDecimal.new('0.4')
  end
end

class TimeInFloatError < StandardError; end
class TimeInFloat::ArgumentError < TimeInFloatError; end
class TimeInFloat::TimeMismatchError < TimeInFloatError; end
class TimeInFloat::NegativeNumberError < TimeInFloatError; end
