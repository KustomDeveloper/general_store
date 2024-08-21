class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :product

  validates :quantity, presence: true, numericality: { greater_than_or_equal_to: 1, only_integer: true }
  validates :unit_price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }

  before_save :set_total_price
  after_save :log_changes

  def total_price
    quantity * unit_price
  end

  private

  def set_total_price
    self.total_price = total_price
  end

  def log_changes
    Rails.logger.info "OrderItem saved - ID: #{id}, Product: #{product_id}, Quantity: #{quantity}, Total Price: #{total_price}"
  end
end