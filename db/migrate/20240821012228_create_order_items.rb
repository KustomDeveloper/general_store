# db/migrate/YYYYMMDDHHMMSS_create_order_items.rb
class CreateOrderItems < ActiveRecord::Migration[7.0]
  def change
    create_table :order_items do |t|
      t.references :order, null: false, foreign_key: true
      t.references :product, null: false, foreign_key: true
      t.integer :quantity, null: false, default: 1
      t.decimal :price, precision: 10, scale: 2, null: false

      t.timestamps
    end

    add_index :order_items, [:order_id, :product_id], unique: true
  end
end