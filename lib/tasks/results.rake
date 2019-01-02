require 'date'

def find_price(coin, date)
  Price.find_by! coin: coin, date: date
rescue ActiveRecord::RecordNotFound => e
  # puts "Price for #{coin.symbol} at #{date} not found"
  # raise e
  Price.new open: 0 # assume coin has died if there is no price
end

task results: :environment do

  years = (2014..2018)
  sizes = [10, 25, 50, 75, 100]

  years.each do |index_year|
    sizes.each do |size|
      index = Index.find_by name: "TOP#{size}-#{index_year}"

      (index_year..years.last).each do |result_year|
        multipliers = []
        index.index_coins.each do |index_coin|
          start_price = find_price index_coin.coin, Date.new(result_year, 1, 1)
          end_price = find_price index_coin.coin, Date.new(result_year+1, 1, 1)
          multiplier = start_price.open == 0 ? 0 : end_price.open.fdiv(start_price.open)
          multipliers << multiplier
        end
        mean_multiplier = multipliers.sum.fdiv multipliers.size
        puts "#{index.name} for #{result_year} has multiplied by: #{mean_multiplier}"
      end
    end
  end
end

task index_results: :environment do
  index = Index.find_by name: "TOP100-2017"
  result_year = 2017
  puts index.name

  multipliers = []
  index.index_coins.each do |index_coin|
    start_price = find_price index_coin.coin, Date.new(result_year, 1, 1)
    end_price = find_price index_coin.coin, Date.new(result_year+1, 1, 1)
    multiplier = start_price.open == 0 ? 0 : end_price.open.fdiv(start_price.open)
    multipliers << multiplier
    puts "#{index_coin.coin.symbol} has multiplied by: #{multiplier}"
  end
  mean_multiplier = multipliers.sum.fdiv multipliers.size
  puts "#{index.name} for #{result_year} has multiplied by: #{mean_multiplier}"
end