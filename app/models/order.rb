# app/models/order.rb
class Order < ApplicationRecord
  has_many :order_items
  has_many :products, through: :order_items

  validates :status, presence: true
  
  def total_price
    order_items.sum { |item| item.quantity * item.price }
  end
end