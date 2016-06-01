module TimeInFloatUtils
  class Calculator
    def self.sum_up(collection:, time_method: nil)
      result = TimeInFloat.new
      return result.to_f unless collection
      # If no time_method is passed, the method will treat collection as an array of numbers
      if time_method
        collection.each { |e| result += TimeInFloat.new(e.public_send(time_method)) }
      else
        collection.each { |e| result += TimeInFloat.new(e) }
      end
      result.to_f
    end
  end
end
