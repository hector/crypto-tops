class CreatePrice < ActiveRecord::Migration[5.0]

  def change
    create_table :prices do |t|
      t.string :from_sym
      t.string :to_sym
      t.date :date
      t.decimal :ratio
    end
    add_index :prices, [:from_sym, :to_sym, :date], unique: true
  end

end