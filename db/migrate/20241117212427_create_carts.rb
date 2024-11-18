class CreateCarts < ActiveRecord::Migration[7.2]
  def change
    create_table :carts do |t|
      t.decimal :subtotal
      t.decimal :discount
      t.decimal :total

      t.timestamps
    end
  end
end
