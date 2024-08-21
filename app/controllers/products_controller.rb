class ProductsController < ApplicationController
  def index
    @products = Product.all
    @order_item = current_order.order_items.new
  end

  def show
    @product = Product.find(params[:id])
    @order_item = current_order.order_items.new
  end

  private

  def current_order
    Order.find_or_create_by(id: session[:order_id]).tap do |order|
      puts "Current Order ID: #{order.id}"
      puts "Order Items: #{order.order_items.map { |oi| { product_id: oi.product_id, quantity: oi.quantity } }}"
    end
  end
end