class CreateProducts < ActiveRecord::Migration[7.2]
  def change
    create_table :products do |t|
      t.string :name
      t.string :brand
      t.string :category
      t.string :pricing_scheme
      t.decimal :price, precision: 8, scale: 2

      t.timestamps
    end
  end
end
