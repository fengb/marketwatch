require 'open-uri'
require 'uri'
require 'json'
require 'marketwatch/version'
require 'date'

module Marketwatch
  def self.flashcharter
    params = {
      ticker: 'AAPL',
      beginDate: Date.today - 7,
      type: 1,
      countryCode: 'US',
      endDate: Date.today,
      frequency: 5,
      docSetUri: [90,103,159,173,183,184,3126,436,2988],
    }

    encoded = encode_params(params)
    open "http://www.marketwatch.com/thunderball.flashcharter/JsonHandler.ashx?#{encoded}" do |f|
      JSON.parse f.read
    end
  end

  def self.encode_params(params)
    array = []
    params.each do |key, value|
      if value.respond_to?(:each)
        value.each do |value|
          array << "#{key}=#{escape value}"
        end
      else
        array << "#{key}=#{escape value}"
      end
    end
    array.join('&')
  end

  def self.escape(value)
    if value.respond_to?(:strftime)
      URI.escape value.strftime('%m/%d/%y %H:%M:%S')
    else
      URI.escape value.to_s
    end
  end
end
