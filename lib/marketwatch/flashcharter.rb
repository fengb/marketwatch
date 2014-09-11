require 'open-uri'
require 'uri'
require 'json'
require 'date'
require 'ostruct'

module Marketwatch
  module Flashcharter
    def self.historical_prices(params={})
      raise unless params[:ticker]

      params[:end_date] ||= Date.today
      # 4 weeks of data just because
      params[:begin_date] ||= params[:end_date] - 28
      params[:type] ||= 1 # TODO: magic number
      params[:country_code] ||= 'US' # TODO: this isn't necessary
      params[:frequency] ||= 5 # TODO: magic number
      params[:doc_set_uri] ||= [90,103,159,173,183,184,3126,436,2988] # TODO: voodoo numbers

      raw = raw_request(params)
      raw['TimeSeriesOhlcDataPoint'].map do |raw_data|
        OpenStruct.new.tap do |o|
          o.raw        = raw_data
          o.open       = raw_data['Open']
          o.high       = raw_data['High']
          o.low        = raw_data['Low']
          o.last       = raw_data['Last']
          o.volume     = raw_data['Volume']
          o.begin_time = Time.at(raw_data['BeginDateUTime']).utc
          o.end_time   = Time.at(raw_data['EndDateUTime']).utc
          # Totally misnamed, but this adheres to the response
          o.begin_date = o.begin_time
          o.end_date   = o.end_time
        end
      end
    end

    def self.raw_request(params)
      encoded = encode_params(params)
      url = "http://www.marketwatch.com/thunderball.flashcharter/JsonHandler.ashx?#{encoded}"
      open url do |f|
        JSON.parse f.read
      end
    end

    def self.encode_params(params)
      preprocessed = preprocess_params(params)
      URI.encode_www_form(preprocessed)
    end

    def self.camel(s)
      s.to_s.gsub /_(.)/ do |match|
        match[1].upcase
      end
    end

    def self.preprocess_params(params)
      {}.tap do |ret|
        params.each do |key, value|
          if value.respond_to?(:strftime)
            ret[camel(key)] = value.strftime('%m/%d/%y %H:%M:%S')
          else
            ret[camel(key)] = value
          end
        end
      end
    end
  end
end
