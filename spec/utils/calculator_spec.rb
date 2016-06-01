require 'spec_helper'

class TClass
  attr_reader :time
  def initialize(time)
    @time = time
  end
end

describe TimeInFloatUtils::Calculator do
  before(:all) do
    @collection = []
    10.times { @collection << TClass.new(1) }
  end

  context '#sum_up' do
    it 'can accept only collection' do
      expect(described_class.sum_up(collection: [1, 1, 1])).to eq(3.0)
    end

    it 'can accept collection of objects with a time method passed in' do
      expect(described_class.sum_up(collection: @collection, time_method: :time)).to eq(10.0)
    end
  end
end
