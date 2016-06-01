require 'spec_helper'

describe TimeInFloat do
  it 'has a version number' do
    expect(TimeInFloat::VERSION).not_to be nil
  end

  context 'class methods' do
    #Checks if a certain number is valid input without normalization
    context '#valid?' do
      it { expect(described_class.valid?("1.1")).to be_truthy }
      it { expect(described_class.valid?(1.1)).to   be_truthy }
      it { expect(described_class.valid?(1)).to     be_truthy }
      it { expect(described_class.valid?("1.6")).to be_falsey }
    end
  end

  context 'initialization' do
    it 'can be initialized without any arguments' do
      expect { described_class.new }.not_to raise_error
    end

    it 'can be initialized by passing float as string' do
      expect { described_class.new('1.1') }.not_to raise_error
    end

    it 'can be initialized by passing float' do
      expect { described_class.new(1.1) }.not_to raise_error
    end

    it 'can be initialized by passing integer' do
      expect { described_class.new(1) }.not_to raise_error
    end

    it 'cannot be initialized by passing float with higher number than 0.6 with normalize param set to false' do
      expect { described_class.new(0.6, normalize: false) }.to raise_error(TimeInFloat::ArgumentError)
      expect { described_class.new(1.7, normalize: false) }.to raise_error(TimeInFloat::ArgumentError)
    end

    it 'correctly normalizes input number if it is over .6 and normaliation is allowed' do
      expect(described_class.new(1.7).decimal).to eq(BigDecimal.new('2.1'))
    end
  end

  context 'arithmetics' do
    let(:item_1) { described_class.new(0.2) }
    let(:item_2) { described_class.new(1.5) }
    let(:item_3) { described_class.new(1.1) }
    let(:item_in_minutes) { described_class.new(1.1, type: :minutes) }
    context '#+' do
      it 'can be added with another TimeInFloat object' do
        summed_object = item_1 + item_3
        expect(summed_object.decimal).to eq(BigDecimal.new('1.3'))
      end

      it 'cannot be added with an integer or a float' do
        expect { item_1 + 1 }.to raise_error(TimeInFloat::ArgumentError)
        expect { item_1 + 1.1 }.to raise_error(TimeInFloat::ArgumentError)
      end

      it 'cannot be added with a FloatInTime object with different type' do
        expect { item_1 + item_in_minutes }.to raise_error(TimeInFloat::TimeMismatchError)
      end

      it 'can correctly handle cases when number after decimal passes .6 after addition' do
        summed_object = item_1 + item_2
        summed_object_2 = item_2 + item_3
        expect(summed_object.decimal).to eq(BigDecimal.new('2.1'))
        expect(summed_object_2.decimal).to eq(BigDecimal.new('3.0'))
      end
    end

    # Defined the same way as addition, but just in case
    context '#-' do
      it 'can be substracted from another TimeInFloat object' do
        substracted = item_2 - item_3
        expect(substracted.decimal).to eq(BigDecimal.new('0.4'))
      end

      it 'can correctly handle cases when number after decimal passes .6 after substraction' do
        substracted = item_3 - item_1
        expect(substracted.decimal).to eq(BigDecimal.new('0.5'))
      end

      it 'raises error if after substraction time becomes negative' do
        expect { item_1 - item_2 }.to raise_error(TimeInFloat::NegativeNumberError)
      end
    end
  end
end
