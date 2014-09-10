require 'marketwatch'

describe Marketwatch do
  describe '.flashcharter' do
    it 'returns 4 weeks of data' do
      chart = Marketwatch.flashcharter(ticker: 'AAPL')
      expect(chart.size).to be_within(2).of(20) # ±2 due to after hours and holidays
    end

    it 'returns list of begin_date/end_date' do
      chart = Marketwatch.flashcharter(ticker: 'AAPL')
      chart.each do |row|
        expect(row.begin_time).to be_a(Time)
        expect(row.end_time).to be_a(Time)
      end
    end

    it 'returns list of open/high/low/last/volume' do
      chart = Marketwatch.flashcharter(ticker: 'AAPL')
      chart.each do |row|
        expect(row.open).to be_a(Numeric)
        expect(row.high).to be_a(Numeric)
        expect(row.low).to be_a(Numeric)
        expect(row.last).to be_a(Numeric)
        expect(row.volume).to be_a(Numeric)
      end
    end

    it 'returns raw data' do
      chart = Marketwatch.flashcharter(ticker: 'AAPL')
      chart.each do |row|
        expect(row.raw).to be_a(Hash)
      end
    end
  end

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
