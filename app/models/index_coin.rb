class IndexCoin < ActiveRecord::Base
  belongs_to :coin
  belongs_to :index
end