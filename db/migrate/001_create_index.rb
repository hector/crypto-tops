class CreateIndex < ActiveRecord::Migration[5.0]

  def change
    create_table :indices do |t|
      t.string :name
      t.string :url
    end
    add_index :indices, :name, unique: true
  end

end