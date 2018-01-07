class CreateIndexCoin < ActiveRecord::Migration[5.0]

  def change
    create_table :index_coins do |t|
      t.string :symbol
      t.decimal :weight
      t.belongs_to :index, index: true
    end
  end

end