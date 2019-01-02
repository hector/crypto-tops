require 'bigdecimal'
require 'date'
require 'open-uri'
require 'nokogiri'

# pages cache to no re-fetch
$pages = {}

def parse_page(url)
  return pages[url] if $pages[url]
  page_str = open url
  page = Nokogiri::HTML(page_str)
  $pages[url] = page
  page
end

def parse_number(text)
  return nil if text == '-'
  BigDecimal(text.gsub(',', ''))
end

namespace :db do
  desc 'Creates indexes, with it coins and historical prices'
  task index: :environment do

    years = [
      { year: 2018, url: 'https://coinmarketcap.com/historical/20180101/' },
      { year: 2017, url: 'https://coinmarketcap.com/historical/20170101/' },
      { year: 2016, url: 'https://coinmarketcap.com/historical/20160103/' },
      { year: 2015, url: 'https://coinmarketcap.com/historical/20150104/' },
      { year: 2014, url: 'https://coinmarketcap.com/historical/20140105/' }
    ]
    sizes = [10, 25, 50, 75, 100]

    Coin.destroy_all
    Index.destroy_all

    years.each do |year|
      page = parse_page year[:url]
      rows = page.css('#currencies-all tbody tr')

      sizes.each do |size|
        index = Index.create! name: "TOP#{size}-#{year[:year]}", url: year[:url]
        n = 0
        rows.each do |row|
          symbol = row.css('td.col-symbol').text
          next if Coin.fiat? symbol

          coin = Coin.find_by symbol: symbol
          unless coin
            # create coin if it does not exist
            url = row.at_css('td.currency-name a.currency-name-container[href]')['href']
            url = "https://coinmarketcap.com#{url}"
            coin = Coin.create! symbol: symbol, url: url

            # fetch all historical prices
            price_page = parse_page "#{url}historical-data/?start=20130428&end=#{Time.now.strftime('%Y%m%d')}"
            raise "#{coin} historical price not in USD" unless price_page.xpath('//*[contains(text(), "Currency in USD")]').size == 1
            price_page.css('#historical-data table tbody tr').each do |price_row|
              tds = price_row.css('td')
              Price.create!(
                coin: coin,
                symbol: symbol,
                date: Date.parse(tds[0].text),
                open: parse_number(tds[1].text),
                high: parse_number(tds[2].text),
                low: parse_number(tds[3].text),
                close: parse_number(tds[4].text),
                volume: parse_number(tds[5].text),
                market_cap: parse_number(tds[6].text),
              )
            end
          end

          # Add coin to index
          IndexCoin.create! coin: coin, symbol: symbol, index: index, weight: 1
          puts "#{index.name} adds #{symbol}"

          n += 1
          break if n >= size
        end
      end
    end

  end
end