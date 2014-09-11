require 'marketwatch'

describe Marketwatch::Flashcharter do
  describe '.info' do
    it 'returns raw data' do
      info = Marketwatch::Flashcharter.info(ticker: 'AAPL')
      expect(info.raw).to be_a(Hash)
    end

    it 'returns range of times' do
      info = Marketwatch::Flashcharter.info(ticker: 'AAPL')
      expect(info.range.first).to be_a(Time)
      expect(info.range.last).to be_a(Time)
    end

    it 'returns basic fields' do
      info = Marketwatch::Flashcharter.info(ticker: 'AAPL')
      expect(info.instrument.common_name).to be =~ /^Apple/
      expect(info.instrument.cusip).to eq('037833100')
    end
  end

  describe '.historical_prices' do
    it 'returns 4 weeks of data' do
      chart = Marketwatch::Flashcharter.historical_prices(ticker: 'AAPL')
      expect(chart.size).to be_within(2).of(20) # ±2 due to after hours and holidays
    end

    it 'returns list of begin_date/end_date/begin_time/end_time' do
      chart = Marketwatch::Flashcharter.historical_prices(ticker: 'AAPL')
      chart.each do |row|
        expect(row.begin_date).to be_a(Time)
        expect(row.end_date).to be_a(Time)
        expect(row.begin_time).to be_a(Time)
        expect(row.end_time).to be_a(Time)
      end
    end

    it 'returns list of open/high/low/last/volume' do
      chart = Marketwatch::Flashcharter.historical_prices(ticker: 'AAPL')
      chart.each do |row|
        expect(row.open).to be_a(Numeric)
        expect(row.high).to be_a(Numeric)
        expect(row.low).to be_a(Numeric)
        expect(row.last).to be_a(Numeric)
        expect(row.volume).to be_a(Numeric)
      end
    end

    it 'returns raw data' do
      chart = Marketwatch::Flashcharter.historical_prices(ticker: 'AAPL')
      chart.each do |row|
        expect(row.raw).to be_a(Hash)
      end
    end
  end

  describe '.encode_params' do
    it 'glues all the params together' do
      encoded = Marketwatch::Flashcharter.encode_params(a: 1, b: 2)
      expect(encoded).to eq('a=1&b=2')
    end

    it 'splits array arguments into separate entries' do
      encoded = Marketwatch::Flashcharter.encode_params(a: [1, 2])
      expect(encoded).to eq('a=1&a=2')
    end

    it 'escapes values' do
      encoded = Marketwatch::Flashcharter.encode_params(a: 'b c')
      expect(encoded).to eq('a=b+c')
    end

    it 'converts dates and times' do
      encoded = Marketwatch::Flashcharter.encode_params(a: Time.at(0).utc)
      expect(encoded).to eq('a=01%2F01%2F70+00%3A00%3A00')
    end

    it 'converts under_scores to camelCase' do
      encoded = Marketwatch::Flashcharter.encode_params(a_b_c: 'd')
      expect(encoded).to eq('aBC=d')
    end
  end
end
