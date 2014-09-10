require 'marketwatch'

describe Marketwatch do
  describe '.encode_params' do
    it 'glues all the params together' do
      encoded = Marketwatch.encode_params(a: 1, b: 2)
      expect(encoded).to eq('a=1&b=2')
    end

    it 'splits array arguments into separate entries' do
      encoded = Marketwatch.encode_params(a: [1, 2])
      expect(encoded).to eq('a=1&a=2')
    end

    it 'escapes values' do
      encoded = Marketwatch.encode_params(a: 'b c')
      expect(encoded).to eq('a=b%20c')
    end

    it 'converts dates and times' do
      encoded = Marketwatch.encode_params(a: Time.at(0).utc)
      expect(encoded).to eq('a=01/01/70%2000:00:00')
    end
  end
end
