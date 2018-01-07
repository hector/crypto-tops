namespace :db do
  desc 'Create coins'
  task coin: :environment do
    require 'cryptocompare'
    Coin.delete_all
    Cryptocompare::CoinList.all["Data"].each_key do |symbol|
      clean_symbol = symbol.gsub '*', ''
      Coin.create symbol: clean_symbol
      puts "#{clean_symbol} created"
    end
  end
end