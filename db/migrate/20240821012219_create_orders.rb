# db/migrate/YYYYMMDDHHMMSS_create_orders.rb
class CreateOrders < ActiveRecord::Migration[7.0]
  def change
    create_table :orders do |t|
      t.string :status, null: false, default: 'cart'
      t.decimal :total, precision: 10, scale: 2

      t.timestamps
    end

    add_index :orders, :status
  end
end