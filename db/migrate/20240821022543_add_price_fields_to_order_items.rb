class AddPriceFieldsToOrderItems < ActiveRecord::Migration[6.1]
  def change
    add_column :order_items, :unit_price, :decimal, precision: 10, scale: 2
    add_column :order_items, :total_price, :decimal, precision: 10, scale: 2
  end
end
