#require 'marketwatch/version'

require 'open-uri'
require 'uri'
require 'json'
require 'date'
require 'ostruct'

module Marketwatch
  def self.flashcharter(params={})
    raise unless params[:ticker]

    params[:endDate] ||= Date.today
    # 4 weeks of data just because
    params[:beginDate] ||= params[:endDate] - 28
    params[:type] ||= 1 # TODO: magic number
    params[:countryCode] ||= 'US' # TODO: this isn't necessary
    params[:frequency] ||= 5 # TODO: magic number
    params[:docSetUri] ||= [90,103,159,173,183,184,3126,436,2988] # TODO: voodoo numbers

    encoded = encode_params(params)
    open "http://www.marketwatch.com/thunderball.flashcharter/JsonHandler.ashx?#{encoded}" do |f|
      raw = JSON.parse f.read
      raw['TimeSeriesOhlcDataPoint'].map do |raw_data|
        OpenStruct.new(
          raw:  raw_data,
          open: raw_data['Open'],
          high: raw_data['High'],
          low:  raw_data['Low'],
          last: raw_data['Last'],
          volume: raw_data['Volume'],
          begin_time: Time.at(raw_data['BeginDateUTime']).utc,
          end_time: Time.at(raw_data['EndDateUTime']).utc,
        )
      end
    end
  end

  def self.encode_params(params)
    coerce_params!(params)
    URI.encode_www_form(params)
  end

  def self.coerce_params!(params)
    params.each do |key, value|
      if value.respond_to?(:strftime)
        params[key] = value.strftime('%m/%d/%y %H:%M:%S')
      end
    end
  end
end
