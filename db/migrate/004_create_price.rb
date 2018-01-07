class CreatePrice < ActiveRecord::Migration[5.0]

  def change
    create_table :prices do |t|
      t.string :symbol
      t.date :date
      t.decimal :open
      t.decimal :high
      t.decimal :low
      t.decimal :close
      t.decimal :volume
      t.decimal :market_cap
      t.belongs_to :coin
    end
    add_index :prices, [:coin_id, :date], unique: true
  end

end