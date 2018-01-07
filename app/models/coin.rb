class Coin < ActiveRecord::Base
  has_many :prices, dependent: :destroy

  validates :symbol, uniqueness: true

  FIAT = {
    USDT: true,
    USNBT: true,
    CNNBT: true,
    EUNBT: true,
    XNBT: true,
    BITUSD: true,
    BITEUR: true,
    BITCNY: true,
  }

  def self.fiat?(symbol)
    FIAT[symbol.to_sym]
  end

end