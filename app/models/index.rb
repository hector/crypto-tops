class Index < ActiveRecord::Base
  has_many :index_coins, dependent: :destroy

  validates :name, uniqueness: true
end