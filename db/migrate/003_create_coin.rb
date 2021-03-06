class CreateCoin < ActiveRecord::Migration[5.0]

  def change
    create_table :coins do |t|
      t.string :symbol
      t.string :url
    end
    add_index :coins, :symbol, unique: true
  end

end