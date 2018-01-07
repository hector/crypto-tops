require 'date'
require 'cryptocompare'

class Price < ActiveRecord::Base

  def self.price(from_sym, to_sym, date)
    price = self.find_by from_sym: from_sym, to_sym: to_sym, date: date
    return price.ratio if price

    ratio = fetch_price from_sym, to_sym, date
    self.create! from_sym: from_sym, to_sym: to_sym, date: date, ratio: ratio
    ratio
  end

  protected

  def self.fetch_price(from_sym, to_sym, date)
    print "Fetching #{from_sym} to #{to_sym} for #{date.strftime('%F')}.."
    results = Cryptocompare::PriceHistorical.find(from_sym, to_sym, 'ts' => date.to_time.to_i)
    ratio = results[from_sym][to_sym]
    puts ". #{ratio}"
    sleep 0.1 # be nice with the API
    ratio
  end

end