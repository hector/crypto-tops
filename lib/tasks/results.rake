require 'date'

task results: :environment do

  years = (2014..2017)
  sizes = [10, 25, 50, 75, 100]

  years.each do |index_year|
    sizes.each do |size|
      index = Index.find_by name: "TOP#{size}-#{index_year}"

      (index_year..years.last).each do |result_year|
        multipliers = []
        index.index_coins.each do |index_coin|
          start_price = Price.price index_coin.symbol, 'USD', Date.new(result_year, 1, 1)
          end_price = Price.price index_coin.symbol, 'USD', Date.new(result_year+1, 1, 1)
          multiplier = start_price == 0 ? 0 : end_price.fdiv(start_price)
          multipliers << multiplier
        end
        mean_multiplier = multipliers.sum.fdiv multipliers.size
        puts "#{index.name} for #{result_year} has multiplied by: #{mean_multiplier}"
      end
    end
  end
end