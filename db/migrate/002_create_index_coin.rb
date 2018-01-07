class CreateIndexCoin < ActiveRecord::Migration[5.0]

  def change
    create_table :index_coins do |t|
      t.string :symbol
      t.decimal :weight
      t.belongs_to :index
      t.belongs_to :coin
    end
    add_index :index_coins, [:index_id, :coin_id], unique: true
  end

end