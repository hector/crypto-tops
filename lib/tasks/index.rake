namespace :db do
  desc 'Creates indexes'
  task index: :environment do
    require 'open-uri'
    require 'nokogiri'

    years = [
      { year: 2017, url: 'https://coinmarketcap.com/historical/20170101/' },
      { year: 2016, url: 'https://coinmarketcap.com/historical/20160103/' },
      { year: 2015, url: 'https://coinmarketcap.com/historical/20150104/' },
      { year: 2014, url: 'https://coinmarketcap.com/historical/20140105/' }
    ]
    sizes = [10, 25, 50, 75, 100]

    Index.destroy_all

    years.each do |year|
      page_str = open(year[:url])
      page = Nokogiri::HTML(page_str)
      tds = page.css('#currencies-all tbody tr td.col-symbol')


      sizes.each do |size|
        index = Index.create! name: "TOP#{size}-#{year[:year]}"
        n = 0
        tds.each do |td|
          symbol = td.text
          next if Coin.fiat? symbol
          next unless Coin.find_by_symbol symbol
          IndexCoin.create! symbol: symbol, index: index, weight: 1
          puts "#{index.name} adds #{symbol}"
          n += 1
          break if n >= size
        end
      end
    end

  end
end